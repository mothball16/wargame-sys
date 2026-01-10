local bootstrapper = {}
local dir = require(script.Parent.Directory)
local modules = script.Parent.Modules
local loader = require(dir.Utility.Loader)

function bootstrapper:Init()
    loader.SpawnAll(loader.LoadDescendants(modules), "PreInit")
    loader.SpawnAll(loader.LoadDescendants(modules), "Init")
end

return bootstrapper