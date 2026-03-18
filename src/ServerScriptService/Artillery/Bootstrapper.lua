local bootstrapper = {}
local dirServer = require(script.Parent.Directory)
local dir = dirServer.Main
local loader = require(dir.Utility.Loader)
local ProjectileRegistry = require(dir.Modules.Projectile.ProjectileRegistry)
local ProjectileController = require(dir.Modules.Projectile.ProjectileController)
local ServerObjectHandler = require(dirServer.mOS.Modules.Core.ServerObjectHandler)

function bootstrapper:Init()
    ServerObjectHandler.ObjectInit:RegisterController("TurretServerController", dirServer.Modules.Turret.TurretServerController)
    ServerObjectHandler.ObjectInit:RegisterPrefabs("Artillery", dir.Configs.Prefabs)

    ProjectileRegistry:Init()
    ProjectileController:Init()
    loader.SpawnAll(loader.LoadDescendants(dirServer.Modules), "Init")
end

return bootstrapper