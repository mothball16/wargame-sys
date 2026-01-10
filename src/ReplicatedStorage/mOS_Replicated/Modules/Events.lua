--[[
conventions:
client -> server: Request<...>
server -> client: On<...>
]]

return {
    Reliable = {
        -- object management
        OnInitialize = "mOS_OnInitialize",
        OnDestroy = "mOS_OnDestroy",

        -- FX
        OnParticlePlayed = "mOS_OnParticlePlayed",
        OnParticleCreated = "mOS_OnParticleCreated",
    };
    Unreliable = {};
}