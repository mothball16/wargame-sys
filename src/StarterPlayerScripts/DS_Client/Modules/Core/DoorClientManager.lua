--#region required
local dirClient = require(script.Parent.Parent.Parent.Directory)
local dir = dirClient.Main
local validator = dir.Validator.new(script.Name)
--#endregion required
--[[
this handles door animation and streaming stuff whatnot
]]

local CS = game:GetService("CollectionService")
local RS = game:GetService("RunService")
local HTTPS = game:GetService("HttpService")
local TweenMoveSequence = require(dir.Modules.Movement.TweenMoveSequence)

local DoorClientManager = {
    activeInstances = {}
}

local function SnapStateAnim(required, instructions, partFolder)
    local key = required:GetAttribute(dir.Consts.DOOR_ROOT_LAST_ANIMKEY_ATTR)
    local sequence = required:GetAttribute(dir.Consts.DOOR_ROOT_STATE_ATTR)
    if not (key and sequence) then return end

    local animKey = assert(instructions[key], "anim key " .. key .. " missing")
    local animSequence = animKey[sequence]
    if not animSequence then
        validator:Warn("animsequence " .. sequence .. " missing from anim key " .. key)
        return
    end
    TweenMoveSequence:ExecuteOnClientImmediate(animSequence, partFolder)
end

local function PlayStateAnim(required, instructions, partFolder)
    local key = required:GetAttribute(dir.Consts.DOOR_ROOT_LAST_ANIMKEY_ATTR)
    local sequence = required:GetAttribute(dir.Consts.DOOR_ROOT_STATE_ATTR)
    if not (key and sequence) then return end

    local animKey = assert(instructions[key], "anim key " .. key .. " missing")
    local animSequence = animKey[sequence]
    if not animSequence then
        validator:Warn("animsequence " .. sequence .. " missing from anim key " .. key)
        return
    end
    return TweenMoveSequence:ExecuteOnClient(animSequence, partFolder)
end

function DoorClientManager:_OnCreated(required: Model)
    if self.activeInstances[required] then
        warn("duplicate door of GUID " .. dir.NetUtils:GetId(required) .. "was attempted to be registered, aborting")
        return
    end

    -- find the prefab instructions
    local prefab = require(required:WaitForChild("InitRoot"):WaitForChild("Prefab").Value)
    local partMover = prefab["PartMover"]
    local instructions = partMover["Instructions"]
    local partFolder = required:FindFirstChild("PartMover")

    if partMover["Use"] ~= "TweenMoveSequence" then
        validator:Warn("use values other than TweenMoveSequence currently not implemented")
        return
    end

    if not partFolder then
        validator:Warn("PartMover folder doesn't exist on model " .. required.Parent.Name .. ". Animations won't work.")
    end

    -- upd for cases where we just streamed in
    SnapStateAnim(required, instructions, partFolder)

    self.activeInstances[required] = {
        required:GetAttributeChangedSignal(dir.Consts.DOOR_ROOT_STATE_ATTR):Connect(function()
            return PlayStateAnim(required, instructions, partFolder)
        end)
    }
end

function DoorClientManager:_OnDestroyed(required)
    local connections = self.activeInstances[required]
    if connections then
        for _, con in pairs(connections) do
            con:Disconnect()
        end
    end
    self.activeInstances[required] = nil
end

function DoorClientManager:Init()
    for _, required in pairs(CS:GetTagged(dir.Consts.DOOR_ROOT_TAG)) do
        self:_OnCreated(required)
    end
    CS:GetInstanceAddedSignal(dir.Consts.DOOR_ROOT_TAG):Connect(function(required)
        self:_OnCreated(required)
    end)
    CS:GetInstanceRemovedSignal(dir.Consts.DOOR_ROOT_TAG):Connect(function(required)
        self:_OnDestroyed(required)
    end)
end


return DoorClientManager
