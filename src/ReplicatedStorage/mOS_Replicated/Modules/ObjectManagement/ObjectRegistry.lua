--#region required
local repl = script.Parent.Parent.Parent
local validator = require(repl.Parent.mOS_Utility.Validator).new(script.Name)
local consts = require(repl.Configs.Constants)
--#endregion required
--[[
stores all created objects for lookup/communication
90% of the usecase for this is just being able to communicate between client and server controllers
]]
local objects = {}
local objectsByClass = {}
local ObjectRegistry = {}

function ObjectRegistry:Get(id)
    return objects[id]
end

function ObjectRegistry:GetRawClassTable(className)
    if not objectsByClass[className] then
        objectsByClass[className] = {}
    end
    return objectsByClass[className]
end


-- obj here is just the metatable holding everything together
function ObjectRegistry:Register(obj, required)
    assert(obj["ClassName"], "classname must exist on objs that serve as roots! use ClassName = script.Name in 99% of cases")
    local ident = validator:HasAttr(required, consts.OBJECT_IDENT_ATTR)

    if type(validator:Exists(obj.Destroy, "destroy method of obj (REQUIRED)")) ~= "function" then
        validator.Error("obj metatable needs a destroy method")
    end

    if objects[ident] then
        warn("object of GUID " ..  ident 
        .. " already exists in table. Object not added, returning old one.")
        return objects[ident], required
    end
    -- add to ID registry
    objects[ident] = obj
    -- add to class registry
    local classTable = self:GetRawClassTable(obj["ClassName"])
    classTable[ident] = obj
    return obj, required
end

function ObjectRegistry:Deregister(required)
    local ident = validator:HasAttr(required, consts.OBJECT_IDENT_ATTR)
    local obj = objects[ident]
    local classTable = self:GetRawClassTable(obj["ClassName"])

    if obj then
        obj:Destroy()
    end

    -- remove from ID registry
    objects[ident] = nil
    -- remove from class registry
    classTable[ident] = nil
end

function ObjectRegistry:WasRegistered(required)
    local ident = validator:HasAttr(required, consts.OBJECT_IDENT_ATTR)
    return objects[ident] ~= nil
end

return ObjectRegistry