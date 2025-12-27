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

local DoorClientManager = {
    activeInstances = {}
}

function DoorClientManager:_OnCreated(required: Model)
    if self.activeInstances[required] then
        warn("duplicate door of GUID " .. dir.NetUtils:GetId(required) .. "was attempted to be registered, aborting")
        return
    end
    self.activeInstances[required] = {
        required:GetAttributeChangedSignal(dir.Consts.DOOR_ROOT_STATE_ATTR):Connect(function()
            
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
