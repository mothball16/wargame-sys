local bootstrapper = {}
local dirServer = require(script.Parent.Directory)
local dir = dirServer.Main
local modules = script.Parent.Modules
local loader = require(dir.Utility.Loader)
local FormatInstructions = require(dir.Modules.Core.InstructionFormatter)
local ServerObjectHandler = require(dirServer.mOS.Modules.Core.ServerObjectHandler)

function bootstrapper:Init()
    ServerObjectHandler.ObjectInit:RegisterController("DoorRoot", dirServer.Modules.Core.DoorRoot)
    ServerObjectHandler.ObjectInit:RegisterPrefabs("Door", dir.Configs.Door)

    FormatInstructions()
    loader.SpawnAll(loader.LoadDescendants(modules), "Init")
end

return bootstrapper