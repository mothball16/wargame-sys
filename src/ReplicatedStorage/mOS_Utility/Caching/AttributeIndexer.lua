--[[
provides the ability to lookup things by their attributes
TODO:
- attribute addition checking
- optimized querying
]]

local AttributeIndexer = {}
AttributeIndexer.__index = AttributeIndexer

AttributeIndexer.ChangeHandleType = {
    HandleChanges = 1,
    IgnoreChanges = 2
}

function AttributeIndexer.new(searchFor: {string})
    local self = setmetatable({
        _cache = {},
        _cleanup = {},
    }, AttributeIndexer)

    for _, v in pairs(searchFor) do
        self._cache[v] = {}
    end
    return self
end

--[[
adds an instance to the cache
]]
function AttributeIndexer:Add(inst: Instance, ChangeHandleType: number)
    ChangeHandleType = ChangeHandleType or AttributeIndexer.ChangeHandleType.HandleChanges
    -- if already tracked then we shouldnt add this again
    if self._cleanup[inst] then return end

    local cleanupData = {
        trackedAttributes = {},
        connections = {}
    }
    for attribute, value in pairs(inst:GetAttributes()) do
        -- if we arent tracking this attribute then skip this one
        local attributeBucket = self._cache[attribute]
        if not attributeBucket then continue end

        self:_AddAttribute(inst, attribute, value)
        cleanupData.trackedAttributes[attribute] = value

        if ChangeHandleType == AttributeIndexer.ChangeHandleType.HandleChanges then
            table.insert(cleanupData.connections,
                inst:GetAttributeChangedSignal(attribute):Connect(function()
                    local newValue = inst:GetAttribute(attribute)
                    self:_RemoveAttribute(inst, attribute, cleanupData.trackedAttributes[attribute])
                    self:_AddAttribute(inst, attribute, newValue)
                    cleanupData.trackedAttributes[attribute] = newValue
                end)
            )
        end
    end
    table.insert(cleanupData.connections, inst.Destroying:Once(function()
        self:Remove(inst)
    end))
    -- provide cleanup data so that we can remove objs without looking through the table
    self._cleanup[inst] = cleanupData
end

function AttributeIndexer:Remove(inst)
    local cleanupData = self._cleanup[inst]
    if cleanupData then
        for _, con in ipairs(cleanupData.connections) do
            if con then con:Disconnect() end
        end
        for attr, val in pairs(cleanupData.trackedAttributes) do
            self:_RemoveAttribute(inst, attr, val)
        end
    end
    self._cleanup[inst] = nil
end

--[[
INTERNAL - DO NOT CALL
]]
function AttributeIndexer:_AddAttribute(inst, attr, value)
    -- find/create values tbl
    local attributeBucket = self._cache[attr]
    local valueBucket = attributeBucket[value]
    if not valueBucket then
        valueBucket = setmetatable({}, {__mode = "k"})
        attributeBucket[value] = valueBucket
    end
    valueBucket[inst] = true
    return valueBucket
end

--[[
INTERNAL - DO NOT CALL
]]
function AttributeIndexer:_RemoveAttribute(inst, attr, value)
    local attributeBucket = self._cache[attr]
    local valueBucket = attributeBucket[value]

    if valueBucket then
        valueBucket[inst] = nil
        if not next(valueBucket) then
            attributeBucket[value] = nil
        end
    end
end

function AttributeIndexer:Query(attr, value)
    local attributeTable = self._cache[attr] or {}
    local insts = {}
    if not value then
        for _, valueBucket in pairs(attributeTable) do
            for inst, _ in pairs(valueBucket) do
                table.insert(insts, inst)
            end
        end
    else
        for inst, _ in pairs(attributeTable[value] or {}) do
           table.insert(insts, inst)
        end
    end
    return insts
end

return AttributeIndexer