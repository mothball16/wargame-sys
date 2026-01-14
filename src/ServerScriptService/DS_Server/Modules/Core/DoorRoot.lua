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

DoorRoot.State = {
    Opened = "Open",
    Closed = "Close",
    Broken = "Broken",
}


DoorRoot.CloseType = {
    AutoClose = "AutoClose",
    ManualClose = "ManualClose",
    ForcedAutoClose = "ForcedAutoClose",
}

local fallbacks = {
    DoorRoot = {
        DoorClipsDuringAnim = false,
        CloseType = DoorRoot.CloseType.AutoClose,
        AutoCloseSeconds = 3,
        InitialState = DoorRoot.State.Closed,
    },
    LockdownControl = {
        ["Lockdown"] = dir.Consts.LOCKDOWN_CONTROL_TYPE.Close,
        ["none"] = dir.Consts.LOCKDOWN_CONTROL_TYPE.NoChange,
    },
}

local function GetRequiredComponents(required)
    local partMover = validator:IsOfClass(required:FindFirstChild("PartMover"), "Folder")
    local scannerDirectory = validator:IsOfClass(required:FindFirstChild("Scanners"), "Folder")
    return partMover, scannerDirectory
end

function DoorRoot.new(args, required)
    assert(args.Build, "doorconfig should be formatted as a table with the built config referencable under key 'Build'")
    local movingParts, scannerDirectory = GetRequiredComponents(required)
    local self = setmetatable({
        ClassName = script.Name,
        required = required,
        id = dir.NetUtils:GetId(required),
        maid = dir.Maid.new(),
        config = dir.Helpers:TableOverwrite(fallbacks, args.Build),
        movingParts = movingParts,
        collidableParts = {},
        scanners = {},
        transitioning = false,
        lock = false,
        state = DoorRoot.State.Closed,
        lockStep = 0,
        transitionStep = 0
    }, DoorRoot)

    -- look 4 promtps
    for _, scannerPart: BasePart in scannerDirectory:GetChildren() do
        local moverKey = scannerPart.Name
        local promptInstance = scannerPart:FindFirstChildOfClass("ProximityPrompt")
        if not promptInstance then
            warn(string.format("prompt instance in part %s doesn't exist on object GUID %s, skippng scanner init",
                moverKey, self.id))
            continue
        end
        local scannerArgs = dir.Helpers:TableCombineNew(
            self.config.Scanner, {
            prompt = promptInstance,
            OnActivated = function(plr)
                return self:Activate(plr, moverKey)
            end
        })
        table.insert(self.scanners, Scanner.new(scannerArgs, required):Mount())
    end

    -- cache parts to setcollide (TODO: use collisiongroups instead)
    for _, movingPart in pairs(self.movingParts:GetChildren()) do
        local mover = movingPart:FindFirstChild("Mover")
        for _, v in pairs(mover:GetChildren()) do
            if v:IsA("Weld") and v.Part1 and v.Part1.CanCollide == true then
                table.insert(self.collidableParts, v.Part1)
            end
        end
    end

    self.required:SetAttribute(dir.Consts.DOOR_ROOT_STATE_ATTR, DoorRoot.State.Closed);

    -- tag the required folder for manager use
    (self.required :: Model):AddTag(dir.Consts.DOOR_ROOT_TAG)

    -- notify listeners
    dirServer.ServerSignals.OnDoorCreated:Fire(self.required)
    self:SetState(self.config.DoorRoot.InitialState, {animKey = "Default"})
    return self
end

-- handles user actions w/ rulecheck
function DoorRoot:Activate(plr, animKey, bypassAuth)
    if self.lock or self.transitioning then
        return dir.Consts.ACCESS_NEUTRAL
    end
    if not (AuthChecks.Check(plr, self.config.AuthChecks) or bypassAuth) then
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


function DoorRoot:SetAnim(key, sequence)
    local animKey = assert(self.config.PartMover.Instructions[key], "anim key " .. key .. " missing")
    local animSequence = animKey[sequence]
    if not animSequence then
        validator:Warn("animsequence " .. sequence .. " missing from anim key " .. key)
        return
    end
    self.required:SetAttribute(dir.Consts.DOOR_ROOT_LAST_ANIMKEY_ATTR, key)
    return TweenMoveSequence:GetAnimLength(animSequence)
end

function DoorRoot:SetLock(lock)
    self.lockStep = (self.lockStep + 1) % 10000
    self.lock = lock
    for _, scanner in self.scanners do
        scanner:SetLock(self.lock or self.transitioning)
    end
end

function DoorRoot:SetTransition(transition)
    self.transitionStep = (self.transitionStep + 1) % 10000
    self.transitioning = transition
    for _, scanner in self.scanners do
        scanner:SetLock(self.lock or self.transitioning)
    end
end

-- sets door state and plays provided transition code
-- TODO: refactor to use Opening/Closing states instead of weird step checking
function DoorRoot:SetState(newState: string, args: {
    animKey: string
})
    local animLength = self:SetAnim(args.animKey, newState)
    self.state = newState
    self.required:SetAttribute(dir.Consts.DOOR_ROOT_STATE_ATTR, newState)
    self:SetTransition(true)

    local curTransitionStep = self.transitionStep
    -- local curLockStep = self.lockStep
    local transitionIsOneStep =
        newState ~= DoorRoot.State.Opened or self.config.DoorRoot.CloseType ~= DoorRoot.CloseType.ForcedAutoClose
    local autoClose = newState == DoorRoot.State.Opened
            and (self.config.DoorRoot.CloseType == DoorRoot.CloseType.AutoClose or self.config.DoorRoot.CloseType == DoorRoot.CloseType.ForcedAutoClose)
    if transitionIsOneStep then
        task.delay(animLength, function()
            if curTransitionStep == self.transitionStep then
                self:SetTransition(false)
                curTransitionStep += 1
            end
        end)
    end
    if autoClose then
        task.delay(self.config.DoorRoot.AutoCloseSeconds + animLength, function()
            if curTransitionStep == self.transitionStep then
                self:SetState(DoorRoot.State.Closed, args)
            end
        end)
    end

    dir.Helpers:Switch (newState) {
        [DoorRoot.State.Opened] = function()
            self:ToggleOpenCollision(true)
        end,
        [DoorRoot.State.Closed] = function()
            task.delay(animLength, function()
                if curTransitionStep == self.transitionStep then
                    self:ToggleOpenCollision(false)
                end
            end)
        end,
        [DoorRoot.State.Broken] = function()
            self:ToggleOpenCollision(true)
        end
    }
end

function DoorRoot:ToggleOpenCollision(open)
    if not self.config.DoorRoot.DoorClipsDuringAnim then
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