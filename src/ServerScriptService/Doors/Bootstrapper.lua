local bootstrapper = {}
local dirServer = require(script.Parent.Directory)
local dir = dirServer.Main
local modules = script.Parent.Modules
local loader = require(dir.Utility.Loader)
local FormatInstructions = require(dir.Modules.Core.InstructionFormatter)
local Framework = require(dir.mOS.Framework)

function bootstrapper:Init()

    Framework:SetController("DoorRoot", dirServer.Modules.Core.DoorRoot)
    Framework:SetPrefabs("Door", dir.Configs.Door)

    FormatInstructions()
    loader.SpawnAll(loader.LoadDescendants(modules), "Init")
end

return bootstrapper