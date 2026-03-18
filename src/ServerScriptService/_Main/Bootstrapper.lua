local bootstrapper = {}
local modules = script.Parent.Modules
local RegisterEvents = require(modules.Core.RegisterEvents)
local MakeIgnoreListIfNotExisting = require(modules.Core.MakeIgnoreListIfNotExisting)
local ObjectBootstrapper = require(modules.Core.ObjectBootstrapper)
local ServerObjectHandler = require(modules.Core.ServerObjectHandler)

function bootstrapper:Init()
    ServerObjectHandler:PreInit()
    RegisterEvents()
    MakeIgnoreListIfNotExisting()
    ObjectBootstrapper()
end

return bootstrapper