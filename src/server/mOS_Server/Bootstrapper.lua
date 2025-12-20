local bootstrapper = {}
local modules = script.Parent.Modules
local RegisterEvents = require(modules.RegisterEvents)
local MakeIgnoreListIfNotExisting = require(modules.MakeIgnoreListIfNotExisting)
local ObjectBootstrapper = require(modules.ObjectBootstrapper)
local ObjectServerHandler = require(modules.ObjectServerHandler)


function bootstrapper:Init()
    RegisterEvents()
    MakeIgnoreListIfNotExisting()
    ObjectServerHandler()

    ObjectBootstrapper()
end

return bootstrapper