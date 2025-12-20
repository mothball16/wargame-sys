--#region requires
local dirClient = require(script.Parent.Parent.Parent.Directory)
local dir = dirClient.Main
local validator = dir.Validator.new(script.Name)
local FX = require(dir.mOS.Modules.FX.FX)
local GoShake = require(dir.Modules.OnHit.GoShake)
local ReplicationRouter = require(dirClient.mOS.Modules.Core.ReplicationRouter)
--#endregion

local GeneralReplHandler = {}

function GeneralReplHandler:Init()
    ReplicationRouter:Route({
        {dir.Events.Reliable.OnParticleCreated, FX.Create},
        {dir.Events.Reliable.OnParticlePlayed, FX.Activate},
        {dir.Events.Reliable.OnShake, GoShake},
    })
end

return GeneralReplHandler