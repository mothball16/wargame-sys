local bootstrapper = {}
local modules = script.Parent.Modules
local RegisterEvents = require(modules.RegisterEvents)
local MakeIgnoreListIfNotExisting = require(modules.MakeIgnoreListIfNotExisting)
local ObjectBootstrapper = require(modules.ObjectBootstrapper)
local ObjectServerLifetimeEventHandler = require(modules.ObjectServerLifetimeEventHandler)


function bootstrapper:Init()
    RegisterEvents()
    MakeIgnoreListIfNotExisting()
    ObjectServerLifetimeEventHandler()

    ObjectBootstrapper()
end

return bootstrapper