local bootstrapper = {}
local dirServer = require(script.Parent.Directory)
local dir = dirServer.Main
local loader = require(dir.Utility.Loader)
local ProjectileRegistry = require(dir.Modules.Projectile.ProjectileRegistry)
local ProjectileController = require(dir.Modules.Projectile.ProjectileController)
local Framework = require(dir.mOS.Framework)

function bootstrapper:Init()
    Framework:SetController("TurretServerController", dirServer.Modules.Turret.TurretServerController)
    Framework:SetPrefabs("Artillery", dir.Configs.Prefabs)

    ProjectileRegistry:Init()
    ProjectileController:Init()
    loader.SpawnAll(loader.LoadDescendants(dirServer.Modules), "Init")
end

return bootstrapper