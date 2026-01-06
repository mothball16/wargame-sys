local CS = game:GetService("CollectionService")
local dirServer = require(script.Parent.Parent.Parent.Directory)
local dir = dirServer.Main
local AttributeIndexer = require(dir.Utility.Caching.AttributeIndexer)
local DoorRoot = require(dirServer.Root.Modules.Core.DoorRoot)

local DoorService = {
    activeInstances = {},
    attributeIndexer = AttributeIndexer.new({dir.Consts.DOOR_ROOT_IDENTIFIER})
}

function DoorService:_OnCreated(required)
    if self.activeInstances[required] then
        warn("duplicate door of GUID " .. dir.NetUtils:GetId(required) .. "was attempted to be registered, aborting")
        return
    end
    self.activeInstances[required] = true
    self.attributeIndexer:Add(required, AttributeIndexer.ChangeHandleType.IgnoreChanges)
end

function DoorService:_OnDestroyed(required)
    self.activeInstances[required] = nil
    self.attributeIndexer:Remove(required)
end

function DoorService:Init()
    -- set orig lockdown state
    game.ServerScriptService:SetAttribute(dir.Consts.LOCKDOWN_ATTR, false)

    --init pre-initialized doors
    for _, required in pairs(CS:GetTagged(dir.Consts.DOOR_ROOT_TAG)) do
        self:_OnCreated(required)
    end

    CS:GetInstanceAddedSignal(dir.Consts.DOOR_ROOT_TAG):Connect(function(required)
        self:_OnCreated(required)
    end)
    CS:GetInstanceRemovedSignal(dir.Consts.DOOR_ROOT_TAG):Connect(function(required)
        self:_OnDestroyed(required)
    end)

    --[[
    -- init door on creation
    dirServer.ServerSignals.OnDoorCreated:Connect(function(...)
        DoorManager:_OnCreated(...)
    end)

    -- destroy doors on destroy
    dirServer.ServerSignals.OnDoorDestroyed:Connect(function(...)
        DoorManager:_OnDestroyed(...)
    end)]]
end

-- retrieve the door object to directly interact with it (danger)
function DoorService:GetDoor(required: Model): typeof(DoorRoot)
    return dir.NetUtils:GetObjectFromRequired(required)
end

-- set the door state of a model
function DoorService:SetDoorState(required: Model, state, args)
    local obj = self:GetDoor(required)
    obj:SetState(state, dir.Helpers:TableOverwrite({
        animKey = "Scriptable",
        forced = true
    }, args or {}))
end

function DoorService:SetDoorLock(required: Model, lock)
    local obj = self:GetDoor(required)
    obj:SetLock(lock)
end

-- retrieve the models of all doors of the DS_Identifier attribute value
function DoorService:QueryForValue(attrValue)
    local doors = {}
    for _, required in ipairs(self.attributeIndexer:Query(dir.Consts.DOOR_ROOT_IDENTIFIER, attrValue)) do
        table.insert(doors, required)
    end
    return doors
end

-- retrieve the models of all doors
function DoorService:QueryAll()
    local doors = {}
    for required, _ in pairs(self.activeInstances) do
        table.insert(doors, required)
    end
    return doors
end

function DoorService:QueryWithSelectorTODO()
    
end

function DoorService:QueryForTagTODO()
    
end

function DoorService.__tostring()
    local s = [[
(DoorManager)
Cache Instances: %s
]]
    return string.format(s, dir.Helpers:GetDictSize())
end
return DoorService