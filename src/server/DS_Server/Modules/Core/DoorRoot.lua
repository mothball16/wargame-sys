--#region required
local dirServer = require(script.Parent.Parent.Parent.Directory)
local dir = dirServer.Main
local validator = dir.Validator.new(script.Name)
local TweenMoveSequence = require(dir.Modules.Movement.TweenMoveSequence)
local AuthChecks = require(script.Parent.AuthChecks)
local Scanner = require(dirServer.Root.Modules.Components.Scanner)
--#endregion required
--[[
handles the actual door functionality
]]


local DoorRoot = {}
DoorRoot.__index = DoorRoot
DoorRoot.CloseType = {
    AutoClose = "AutoClose",
    ManualClose = "ManualClose",
    ForcedAutoClose = "ForcedAutoClose",
}
DoorRoot.State = {
    Opened = "Open",
    Closed = "Close",
    Broken = "Broken",
}

local fallbacks = {
    DoorRoot = {
        DisableCollisionOnOpen = true,
        CloseType = DoorRoot.CloseType.AutoClose,
        AutoCloseSeconds = 3,
    },
}

local function _checkSetup(required)
    local partMover = validator:IsOfClass(required:FindFirstChild("PartMover"), "Folder")
    local scannerDirectory = validator:IsOfClass(required:FindFirstChild("Scanners"), "Folder")
    return partMover, scannerDirectory
end

function DoorRoot.new(args, required)
    local movingParts, scannerDirectory = _checkSetup(required)
    local self = setmetatable({
        ClassName = script.Name,
        required = required,
        id = dir.NetUtils:GetId(required),
        maid = dir.Maid.new(),
        config = dir.Helpers:TableOverwrite(fallbacks, args),
        movingParts = movingParts,
        collidableParts = {},
        scanners = {},
        lock = false,
        state = DoorRoot.State.Closed,
        step = 0
    }, DoorRoot)

    -- look 4 promtps
    for _, scannerEntry in scannerDirectory:GetChildren() do
        local moverKey = scannerEntry.Name
        local promptInstance = scannerEntry.Value :: ProximityPrompt
        table.insert(self.scanners, Scanner.new(dir.Helpers:TableCombineNew(
            self.config.Scanner, {
            prompt = promptInstance,
            OnActivated = function(plr)
                return self:Activate(plr, moverKey)
            end
        }), required):Mount())
    end

    -- cache parts to setcollide (TODO: use collisiongroups instead)
    for _, movingPart in pairs(self.movingParts:GetChildren()) do
        local mover = movingPart.Mover.Value
        for _, v in pairs(mover:GetChildren()) do
            if v:IsA("Weld") and v.Part1 and v.Part1.CanCollide == true then
                table.insert(self.collidableParts, v.Part1)
            end
        end
    end

    -- set default partmover instructions if not already set
    local instructions = self.config.PartMover.Instructions
    if not instructions["Default"] then
        -- for common names that would equate to default
        instructions["Default"] = instructions["Open"] or instructions["Front"]
        -- for idiot config
        if not instructions["Default"] then
            warn("door should have a default PartMover instruction for script interactions, using a random key (BAD)")
            warn(args)
            instructions["Default"] = next(instructions)
        end
    end
    -- ensure scripts have an interactable animKey
    instructions["Scriptable"] = instructions["Scriptable"] or instructions["Default"]

    self.required:SetAttribute(dir.Consts.DOOR_ROOT_STATE_ATTR, DoorRoot.State.Closed)

    -- notify listeners
    dirServer.ServerSignals.OnDoorCreated:Fire(self.required)
    return self
end

-- handles user actions w/ rulecheck
function DoorRoot:Activate(plr, animKey, bypassAuth)
    if self.lock then
        return dir.Consts.ACCESS_NEUTRAL
    end
    if not (AuthChecks:Check(plr, self.config.AuthChecks) or bypassAuth) then
        return dir.Consts.ACCESS_DENIED
    end

    dir.Helpers:Switch (self.state) {
        [DoorRoot.State.Broken] = function()
            return dir.Consts.ACCESS_NEUTRAL
        end,
        [DoorRoot.State.Opened] = function()
            self:SetState(DoorRoot.State.Closed, {animKey = animKey})
        end,
        [DoorRoot.State.Closed] = function()
            self:SetState(DoorRoot.State.Opened, {animKey = animKey})
        end
    }

    return dir.Consts.ACCESS_ACCEPTED
end


function DoorRoot:PlayAnim(key, sequence)
    local animKey = assert(self.config.PartMover.Instructions[key], "anim key " .. key .. " missing")
    local animSequence = animKey[sequence]
    if not animSequence then
        validator:Warn("animsequence " .. sequence .. " missing from anim key " .. key)
        return
    end
    return TweenMoveSequence:ExecuteOnServer(animSequence, self.movingParts)
end

function DoorRoot:SetLock(lock)
    self.step = (self.step + 1) % 10000
    for _, scanner in self.scanners do
        scanner:SetLock(lock)
    end
end

-- sets door state and plays provided transition code
function DoorRoot:SetState(newState: string, args: {
    animKey: string
})
    self:SetLock(true)
    self.state = newState
    local animLength = self:PlayAnim(args.animKey, newState)
    local curStep = self.step

    -- if door is being opened and under the ForcedAutoClose setting, we don't want to be able to interact w/ it till the process is done
    if newState ~= DoorRoot.State.Opened or self.config.DoorRoot.CloseType ~= DoorRoot.CloseType.ForcedAutoClose then 
        task.delay(animLength, function()
            if curStep == self.step then
                self:SetLock(false)
            end
        end)
    end

    self.required:SetAttribute(dir.Consts.DOOR_ROOT_STATE_ATTR, newState)
    dir.Helpers:Switch (newState) {
        [DoorRoot.State.Opened] = function()
            self:ToggleOpenCollision(true)
            if self.config.DoorRoot.CloseType ~= DoorRoot.CloseType.ManualClose then
                task.delay(self.config.DoorRoot.AutoCloseSeconds + animLength, function()
                    if curStep == self.step then
                        self:SetState(DoorRoot.State.Closed, args)
                    end
                end)
            end
        end,
        [DoorRoot.State.Closed] = function()
            self:ToggleOpenCollision(false)
        end,
        [DoorRoot.State.Broken] = function()
            self:ToggleOpenCollision(true)
        end
    }
end

function DoorRoot:ToggleOpenCollision(open)
    if self.config.DoorRoot.DisableCollisionOnOpen then
        for _, v in pairs(self.collidableParts) do
            v.CanCollide = not open
        end
    end
end

function DoorRoot:Destroy()
    dirServer.ServerSignals.OnDoorDestroyed:Fire(self.required)
    self.maid:DoCleaning()
end
return DoorRoot