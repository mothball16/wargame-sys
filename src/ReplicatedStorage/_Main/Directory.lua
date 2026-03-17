local share =           game.ReplicatedStorage.m_Shared
local root =            script.Parent
local utility =         share._Utilities
local isServer =        game:GetService("RunService"):IsServer()

local modules =         root.Modules
local configs =         root.Configs
return {
    Shared =            root,
    Configs =           configs,
    Modules =           modules,
    Utility =           utility,
    isServer =          isServer,

    ServerSignals =     require(modules.ServerSignals),
    Consts =            require(configs.Constants),
    Maid =              require(utility.Maid),
    Validator =         require(utility.Validator),
    Helpers =           require(utility.Helpers),
    NetUtils =          require(utility.NetUtils),
    Net =               require(utility.Net),
    Events =            require(modules.Events),
}

