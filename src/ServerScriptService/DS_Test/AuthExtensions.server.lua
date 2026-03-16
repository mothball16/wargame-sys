local dirServer = require(game.ServerScriptService.Server.Doors.Directory)
local dir = dirServer.Main
local AuthChecks = require(dirServer.Modules.Core.AuthChecks)

AuthChecks.NotLockdown = function()
   return game.ReplicatedStorage:GetAttribute(dir.Consts.LOCKDOWN_ATTR) ~= "Lockdown"
end