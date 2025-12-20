local bootstrapper = {}
local dirClient = require(script.Parent.Directory)
local dir = dirClient.Main
local loader = require(dir.Utility.Loader)
local modules = script.Parent.Modules

function bootstrapper:Init()

    loader.SpawnAll(loader.LoadDescendants(modules), "Init")
end

return bootstrapper