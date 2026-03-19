local bootstrapper = {}
local dirServer = require(script.Parent.Directory)
local dir = dirServer.Main
local loader = require(dir.Utility.Loader)
local ProjectileRegistry = require(dir.Modules.Projectile.ProjectileRegistry)
local ProjectileController = require(dir.Modules.Projectile.ProjectileController)
local Framework = require(dir.mOS.Framework)

function bootstrapper:Init()
    Framework:SetController("TurretServerRoot", dirServer.Modules.Turret.TurretServerRoot)
    Framework
        :SetPrefabs("Artillery", dir.Configs.Prefabs.Artillery)
        :SetPrefabs("Artillery__RefillTool", dir.Configs.Prefabs.RefillTool)



    ProjectileRegistry:Init()
    ProjectileController:Init()
    loader.SpawnAll(loader.LoadDescendants(dirServer.Modules), "Init")
end

return bootstrapper