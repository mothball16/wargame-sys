-- TODO: this should simplify stuff regarding higher level architecture stuff

--[[
registering of prefabs and controllers
(faster) initialization of modules
]]
local RS = game:GetService("RunService")
local isServer = RS:IsServer()
local dir = require(script.Parent.Directory)
local ObjectHandler

local Framework = {}


function Framework:LocateDependencies()
    if isServer then
        local dirServer = require(game.ServerScriptService.m_Server._Main.Directory)
        ObjectHandler = require(dirServer.Modules.Core.ServerObjectHandler)
    else
        local dirClient = require(game.Players.LocalPlayer.PlayerScripts.m_Client._Main.Directory)
        ObjectHandler = require(dirClient.Modules.Core.ClientObjectHandler)
    end
end
Framework:LocateDependencies()

function Framework:GetPrefab(systemType: string, prefab: string)
    ObjectHandler.ObjectInit.registeredPrefabs:Select({[systemType] = prefab})
    return ObjectHandler.ObjectInit.registeredPrefabs:Get(systemType)
end

function Framework:GetController(controller: string)
    return ObjectHandler.ObjectInit.registeredControllers[controller]
end

return Framework