local bootstrapper = {}
local dirClient = require(script.Parent.Directory)
local dir = dirClient.Main
local loader = require(dir.Utility.Loader)
local modules = script.Parent.Modules
local ReplicationRouter = require(dirClient.mOS.Modules.Core.ReplicationRouter)
local TweenMoveSequence = require(dir.Modules.Movement.TweenMoveSequence)
local FormatInstructions = require(dir.Modules.Core.InstructionFormatter)
local ClientObjectHandler = require(dirClient.mOS.Modules.Core.ClientObjectHandler)

function bootstrapper:Init()
    FormatInstructions()
    -- register stuff to objecthandler so it knows what to initialize
    ClientObjectHandler.ObjectInit:RegisterPrefabs("Door", dir.Configs.Door)

    ReplicationRouter:Route({
        {dir.Events.Reliable.PlayAnimation, TweenMoveSequence}
    })

    loader.SpawnAll(loader.LoadDescendants(modules), "Init")
end

return bootstrapper