local DoorConfig = require(game.ReplicatedStorage.m_Shared.Doors.Configs.DoorConfig)

local Door: DoorConfig.DoorSetup = {
    Classes = {
        "Auth_LockdownOnly",
        "CloseType_ForcedAuto", "OpenType_Manual",
        "Scanner_Hidden",
    },
    Sequence = {
        Type = "SingleDirectionalDoor",
        Args = {1, 1, "PushDoorOpen", "PushDoorClose"}
    }
}

return DoorConfig.Build(Door)