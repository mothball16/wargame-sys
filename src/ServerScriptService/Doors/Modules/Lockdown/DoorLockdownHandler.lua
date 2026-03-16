--#region required
local dirServer = require(script.Parent.Parent.Parent.Directory)
local dir = dirServer.Main
local validator = dir.Validator.new(script.Name)
local SSS = game.ServerScriptService

local DoorRoot = require(dirServer.Modules.Core.DoorRoot)
local DoorService = require(dirServer.Modules.Core.DoorService)
--#endregion required
--[[
Handles door interactions on a lockdown event n stuff
]]


local DoorLockdownHandler = {}


function DoorLockdownHandler:Init()
    game.ReplicatedStorage:GetAttributeChangedSignal(dir.Consts.LOCKDOWN_ATTR):Connect(function()
        local value = game.ReplicatedStorage:GetAttribute(dir.Consts.LOCKDOWN_ATTR)
        for _, door in ipairs(DoorService:QueryAll()) do
            local DoorObj = DoorService:GetDoor(door)
            local controlType = DoorObj.config.LockdownControl
                and DoorObj.config.LockdownControl[value] or nil
            if not controlType then continue end

            dir.Helpers:Switch (controlType) {
                [dir.Consts.LOCKDOWN_CONTROL_TYPE.Close] = function()
                    DoorObj:SetState(DoorObj.State.Closed, {animKey = "Scriptable"})
                end,
                [dir.Consts.LOCKDOWN_CONTROL_TYPE.Open] = function()
                    DoorObj:SetState(DoorObj.State.Opened, {animKey = "Scriptable"})
                end,
                [dir.Consts.LOCKDOWN_CONTROL_TYPE.NoChange] = function() end,
                default = function()
                    warn(`unhandled control type: {controlType}`)
                end
            }
        end
    end)
end

return DoorLockdownHandler

