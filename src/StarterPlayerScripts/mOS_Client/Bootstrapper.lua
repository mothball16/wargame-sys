local bootstrapper = {}
local modules = script.Parent.Modules
local dirClient = require(script.Parent.Directory)
local dir = dirClient.Main
local loader = require(dir.Utility.Loader)
function bootstrapper:Init()
    loader.SpawnAll(loader.LoadDescendants(modules), "PreInit")
    loader.SpawnAll(loader.LoadDescendants(modules), "Init")
end

return bootstrapper