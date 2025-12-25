local dirServer = require(script.Parent.Parent.Parent.Directory)
local dir = dirServer.Main
local AttributeIndexer = require(dir.Utility.Caching.AttributeIndexer)
local DoorRoot = require(dirServer.Root.Modules.Core.DoorRoot)
local DoorManager = {}

DoorManager.Cache = AttributeIndexer.new({
    dir.Consts.DOOR_ROOT_IDENTIFIER
})

function DoorManager:_OnCreated(required)
    self.Cache:Add(required, AttributeIndexer.ChangeHandleType.IgnoreChanges)
end

function DoorManager:_OnDestroyed(required)
    self.Cache:Remove(required)
end

function DoorManager:Init()
    dirServer.ServerSignals.OnDoorCreated:Connect(function(...)
        DoorManager:_OnCreated(...)
    end)
    dirServer.ServerSignals.OnDoorDestroyed:Connect(function(...)
        DoorManager:_OnDestroyed(...)
    end)
end

-- retrieve the door object to directly interact with it (danger)
function DoorManager:GetDoor(required: Model): typeof(DoorRoot)
    return dir.NetUtils:GetObjectFromRequired(required)
end

-- set the door state of a model
function DoorManager:SetDoorState(required: Model, state, args)
    local obj = self:GetDoor(required)
    obj:SetState(state, dir.Helpers:TableOverwrite({
        animKey = "Scriptable",
        forced = true
    }, args or {}))
end

-- set the door state of several models
function DoorManager:SetDoorStates(requireds: {Model}, state, args)
    for _, required in ipairs(requireds) do
        self:SetDoorState(required, state, args)
    end
end

-- retrieve the models of all doors of the DS_Identifier attribute value
function DoorManager:QueryForValue(attrValue)
    local doors = {}
    for _, required in ipairs(self.Cache:Query(dir.Consts.DOOR_ROOT_IDENTIFIER, attrValue)) do
        table.insert(doors, required)
    end
    return doors
end

function DoorManager:QueryWithSelectorTODO()
    
end

function DoorManager:QueryForTagTODO()
    
end

function DoorManager.__tostring()
    local s = [[
(DoorManager)
Cache Instances: %s
]]
    return string.format(s, dir.Helpers:GetDictSize())
end
return DoorManager