local bootstrapper = {}
local dirServer = require(script.Parent.Directory)
local dir = dirServer.Main
local modules = script.Parent.Modules
local loader = require(dir.Utility.Loader)
local FormatInstructions = require(dir.Modules.Core.InstructionFormatter)

function bootstrapper:Init()
    FormatInstructions()
    loader.SpawnAll(loader.LoadDescendants(modules), "Init")
end

return bootstrapper