--#region required
local repl = script.Parent.Parent.Parent
local validator = require(repl.Parent._Utilities.Validator).new(script.Name)
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
    local ident = validator:HasAttr(required, consts.OBJECT_IDENT_ATTR)

    if type(validator:Exists(obj.Destroy, "destroy method of obj (REQUIRED)")) ~= "function" then
        validator.Error("obj metatable needs a destroy method")
    end

    if objects[ident] then
        warn("object of GUID " ..  ident 
        .. " already exists in table. Object not added, returning old one.")
        return objects[ident], required
    end

    local classTable = self:GetRawClassTable(obj["ClassName"])

    -- add to registries
    objects[ident] = obj
    classTable[ident] = obj
    if consts.PRINT_OBJ_LIFETIME then
        self:Dump()
    end
    return obj, required
end

function ObjectRegistry:Deregister(required)
    local ident = validator:HasAttr(required, consts.OBJECT_IDENT_ATTR)
    local obj = objects[ident]

    if obj then
        local classTable = self:GetRawClassTable(obj["ClassName"])
        classTable[ident] = nil
        objects[ident] = nil

        obj:Destroy()
    end
end

function ObjectRegistry:WasRegistered(required)
    local ident = validator:HasAttr(required, consts.OBJECT_IDENT_ATTR)
    return objects[ident] ~= nil
end

function ObjectRegistry:Dump()
    warn("=== ObjectRegistry Dump ===")
    print("Objects by ID:", objects)
    print("Objects by Class:", objectsByClass)
    warn("===========================")
end


return ObjectRegistry