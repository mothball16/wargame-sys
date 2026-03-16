--[[
conventions:
client -> server: Request<...>
server -> client: On<...>
]]


return {
    Reliable = {
        -- projecitle replication
        OnProjectileDestroyed = "mAS_OnProjectileDestroyed",
        RequestProjectileDestroy = "mAS_RequestProjectileDestroy",

        OnProjectileCreated = "mAS_OnProjectileCreated",
        RequestProjectileCreate = "mAS_RequestProjectileCreate",

        OnProjectileHit = "mAS_OnProjectileHit",
        RequestProjectileHit = "mAS_RequestProjectileHit",

        -- attachment management
        RequestAttachmentDetach = "mAS_RequestAttachmentDetach",
        RequestAttachmentUse = "mAS_RequestAttachmentUse",
        RequestAttachmentAttach = "mAS_RequestAttachmentAttach",
        OnAttachStateModified = "mAS_OnAttachStateModified", -- (required), calls clients to refresh the attachstate. this would only be connected to within clientcontrollers that need the information

        -- fx
        OnParticlePlayed = "mAS_OnParticlePlayed",
        OnParticleCreated = "mAS_OnParticleCreated",

        -- shake
        OnShake = "mAS_OnShake",
    };
    Unreliable = {
        -- turret weld stuff
        OnTurretWeldsUpdated = "mAS_OnTurretWeldsUpdated",


        -- projectile replication
        OnProjectileUpdated = "mAS_OnProjectileUpdated",
        RequestProjectileUpdate = "mAS_RequestProjectileUpdate",
    }
}