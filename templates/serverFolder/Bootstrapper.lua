local bootstrapper = {}
local dirServer = require(script.Parent.Directory)
local dir = dirServer.Main
local modules = script.Parent.Modules
local loader = require(dir.Utility.Loader)

function bootstrapper:Init()

    loader.SpawnAll(loader.LoadDescendants(modules), "Init")
end

return bootstrapper