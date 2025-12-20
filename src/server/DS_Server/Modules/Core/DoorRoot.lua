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

local fallbacks = {
    DoorRoot = {
        DisableCollisionOnOpen = true,
    },
}

local DoorRoot = {}
DoorRoot.__index = DoorRoot

local function _checkSetup(required)
    local partMover = validator:IsOfClass(required:FindFirstChild("PartMover"), "Folder")
    local scannerDirectory = validator:IsOfClass(required:FindFirstChild("Scanners"), "Folder")
    return partMover, scannerDirectory
end

function DoorRoot.new(args, required)
    local movingParts, scannerDirectory = _checkSetup(required)
    local self = setmetatable({
        maid = dir.Maid.new(),
        config = dir.Helpers:TableOverwrite(fallbacks, args),
        movingParts = movingParts,
        collidableParts = {},
        scanners = {},
        lock = false,
        open = false
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
        })):Mount())
    end

    -- cache parts to setcollide
    for _, movingPart in pairs(self.movingParts:GetChildren()) do
        local mover = movingPart.Mover.Value
        for _, v in pairs(mover:GetChildren()) do
            if v:IsA("Weld") and v.Part1 and v.Part1.CanCollide == true then
                table.insert(self.collidableParts, v.Part1)
            end
        end
    end
    return self
end

function DoorRoot:Activate(plr, key)
    if self.lock then
        return dir.Consts.ACCESS_NEUTRAL
    end
    if not AuthChecks:Check(plr, self.config.AuthChecks) then
        return dir.Consts.ACCESS_DENIED
    end

    -- access accepted
    TweenMoveSequence:ExecuteOnServer(
        self.config.PartMover.Instructions[key],
        self.movingParts)
    self:SetLock(true)
    self:SetOpen(true)
    task.delay(self.config.DoorRoot.OpenCooldown, function()
        self:SetLock(false)
        self:SetOpen(false)
    end)
    return dir.Consts.ACCESS_ACCEPTED
end

function DoorRoot:SetLock(lock)
    for _, scanner in self.scanners do
        scanner:SetLock(lock)
    end
end

function DoorRoot:SetOpen(open)
    self.open = open
    print(self.config.DoorRoot)
    if self.config.DoorRoot.DisableCollisionOnOpen then
        for _, v in pairs(self.collidableParts) do
            v.CanCollide = not open
        end
    end

end

function DoorRoot:Destroy()
    self.maid:DoCleaning()
end
return DoorRoot