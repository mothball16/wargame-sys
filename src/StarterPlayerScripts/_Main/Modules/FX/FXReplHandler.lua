--#region requires
local dirClient = require(script.Parent.Parent.Parent.Directory)
local dir = dirClient.Main
local FX = require(dir.Modules.FX.FX)
local ReplicationRouter = require(dirClient.mOS.Modules.Core.ReplicationRouter)
--#endregion

local FXReplHandler = {}

function FXReplHandler:Init()
    print("yo.. gurt")
    ReplicationRouter:Route({
       -- {dir.Events.Reliable.OnParticleCreated, FX.Create},
        {dir.Events.Reliable.OnParticlePlayed, FX.Activate},
    })
end

return FXReplHandler