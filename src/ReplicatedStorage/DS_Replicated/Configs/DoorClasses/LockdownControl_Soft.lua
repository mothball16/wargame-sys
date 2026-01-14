local dir = require(game.ReplicatedStorage.Shared.DS_Replicated.Directory)
local Door = require(dir.Configs.DoorConfig)
local CONTROL_TYPE = dir.Consts.LOCKDOWN_CONTROL_TYPE

-- only closes on lockdown, but doesn't change on lockdown lift (default choice)
local Class: Door.DoorConfig = {
    LockdownControl = {
        ["Lockdown"] = CONTROL_TYPE.Close,
        ["none"] = CONTROL_TYPE.NoChange,
    },
}
return Class