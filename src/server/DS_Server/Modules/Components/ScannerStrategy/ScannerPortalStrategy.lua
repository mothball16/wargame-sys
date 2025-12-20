--#region required
local dirServer = require(script.Parent.Parent.Parent.Parent.Directory)
local dir = dirServer.Main
--#endregion required
--[[
this does the whole FX thing with the scanner
]]

local ScannerPortalStrategy = {}
local cache = {}


local keywords = {
    dir.Consts.ACCESS_ACCEPTED,
    dir.Consts.ACCESS_DENIED,
    dir.Consts.ACCESS_NEUTRAL
}

local function _FindEssentialParts(model: Model)
    local parts = {}
    for _, word in pairs(keywords) do
        parts[word] = {}
    end
    for _, thing in ipairs(model:GetDescendants()) do
        if table.find(keywords, thing.Name) then
            table.insert(parts[thing.Name], thing)
        end
    end
    return parts
end

function ScannerPortalStrategy:ToggleOn(thing, keyword)
    dir.Helpers:Switch (thing.ClassName) {
        ["Decal"] = function()
            (thing :: Decal).Transparency = thing:GetAttribute("OnTrans") or 0
        end,
        ["ImageLabel"] = function()
            (thing :: ImageLabel).Visible = true
        end,
        ["Folder"] = function()
            for _, v in ipairs(thing:GetChildren()) do
                self:ToggleOn(v, keyword)
            end
        end,
        ["Sound"] = function()
            (thing :: Sound):Play()
        end,
        default = function() end
    }
end

function ScannerPortalStrategy:ToggleOff(thing, keyword)
    dir.Helpers:Switch (thing.ClassName) {
        ["Decal"] = function()
            (thing :: Decal).Transparency = thing:GetAttribute("OffTrans") or 1
        end,
        ["ImageLabel"] = function()
            (thing :: ImageLabel).Visible = false
        end,
        ["Folder"] = function()
            for _, v in ipairs(thing:GetChildren()) do
                self:ToggleOff(v, keyword)
            end
        end,
        default = function() end
    }
end

function ScannerPortalStrategy:Execute(model: Model, status)
    local scannerEssentialParts = cache[model]

    -- this whole thing probably doesnt really take that much resources but
    -- calling GetDescendants every time for something that only needs to be calculated once
    -- seems kind of wasteful
    if not scannerEssentialParts then
        cache[model] = _FindEssentialParts(model)
        scannerEssentialParts = cache[model]
        -- to handle mem leaks
        model.Destroying:Once(function()
            cache[model] = nil
        end)
    end

    for state, parts in pairs(scannerEssentialParts) do
        if state == status then
            for _, v in pairs(parts) do
                self:ToggleOn(v, status)
            end
        else
            for _, v in pairs(parts) do
                self:ToggleOff(v, status)
            end
        end
    end
end

return ScannerPortalStrategy
