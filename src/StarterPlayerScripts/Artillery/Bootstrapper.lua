local bootstrapper = {}
local dirClient = require(script.Parent.Directory)
local dir = dirClient.Main
local loader = require(dir.Utility.Loader)
local modules = script.Parent.Modules
local ProjectileRegistry = require(dir.Modules.Projectile.ProjectileRegistry)
local ProjectileController = require(dir.Modules.Projectile.ProjectileController)
local Framework = require(dir.mOS.Framework)
function bootstrapper:Init()
    -- register stuff to objecthandler so it knows what to initialize
    Framework
        :SetController("TurretPlayerRoot", dirClient.Modules.Turret.TurretPlayerRoot)
        :SetController("AttachmentToolRoot", dirClient.Modules.AttachmentSystem.AttachmentToolRoot)
    Framework
        :SetPrefabs("Artillery", dir.Configs.Prefabs.Artillery)
        :SetPrefabs("Artillery__RefillTool", dir.Configs.Prefabs.RefillTool)

    -- init replicated modules
    ProjectileRegistry:Init()
    ProjectileController:Init()

    -- init client modules
    loader.SpawnAll(loader.LoadDescendants(modules), "Init")
end

return bootstrapper