--#region required
local dir = require(script.Parent.Parent.Parent.Directory)
local validator = dir.Validator.new(script.Name)
--#endregion required
--[[
This is the purpose of this script.
]]

local LockdownNotifierRoot = {}
LockdownNotifierRoot.__index = LockdownNotifierRoot

local function _checkSetup(required)
    
end

function LockdownNotifierRoot.new(args, required)
    local self = setmetatable({}, LockdownNotifierRoot)
    
    return self
end

return LockdownNotifierRoot