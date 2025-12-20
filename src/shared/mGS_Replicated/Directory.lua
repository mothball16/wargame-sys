local share =           game.ReplicatedStorage.Shared
local root =            script.Parent
local utility =         share.mOS_Utility

local modules =         root.Modules
local configs =         root.Configs
local assets =          root.Assets
return {
    Shared =            root,
    Configs =           configs,
    Modules =           modules,
    Utility =           utility,
    Assets =            assets,

    Maid =              require(utility.Maid),
    Validator =         require(utility.Validator),
    Helpers =           require(utility.Helpers),
    NetUtils =          require(utility.NetUtils),
    Net =               require(utility.Net),
}
