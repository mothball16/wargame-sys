local bootstrapper = {}
local dirClient = require(script.Parent.Directory)
local dir = dirClient.Main
local loader = require(dir.Utility.Loader)
local modules = script.Parent.Modules
local ReplicationRouter = require(dirClient.mOS.Modules.Core.ReplicationRouter)
local TweenMoveSequence = require(dir.Modules.Movement.TweenMoveSequence)
function bootstrapper:Init()
    ReplicationRouter:Route({
        {dir.Events.Reliable.PlayAnimation, TweenMoveSequence}
    })
    loader.SpawnAll(loader.LoadDescendants(modules), "Init")
end

return bootstrapper