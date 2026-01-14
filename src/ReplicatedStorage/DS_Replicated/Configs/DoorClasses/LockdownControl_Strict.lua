local dir = require(game.ReplicatedStorage.Shared.DS_Replicated.Directory)
local Door = require(dir.Configs.DoorConfig)
local CONTROL_TYPE = dir.Consts.LOCKDOWN_CONTROL_TYPE
local Class: Door.DoorConfig = {
    LockdownControl = {
        ["Lockdown"] = CONTROL_TYPE.Close,
        ["none"] = CONTROL_TYPE.Open,
    },
}
return Class