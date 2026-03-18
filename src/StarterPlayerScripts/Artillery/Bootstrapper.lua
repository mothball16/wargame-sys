local bootstrapper = {}
local dirClient = require(script.Parent.Directory)
local dir = dirClient.Main
local loader = require(dir.Utility.Loader)
local modules = script.Parent.Modules
local ProjectileRegistry = require(dir.Modules.Projectile.ProjectileRegistry)
local ProjectileController = require(dir.Modules.Projectile.ProjectileController)
local ClientObjectHandler = require(dirClient.mOS.Modules.Core.ClientObjectHandler)

function bootstrapper:Init()
    -- register stuff to objecthandler so it knows what to initialize
    ClientObjectHandler.ObjectInit:RegisterController("TurretPlayerRoot", dirClient.Modules.Turret.TurretPlayerRoot)
    ClientObjectHandler.ObjectInit:RegisterPrefabs("Artillery", dir.Configs.Prefabs)

    -- init replicated modules
    ProjectileRegistry:Init()
    ProjectileController:Init()

    -- init client modules
    loader.SpawnAll(loader.LoadDescendants(modules), "Init")
end

return bootstrapper