local DoorConfig = require(game.ReplicatedStorage.Shared.DS_Replicated.Configs.DoorConfig)

local Door: DoorConfig.DoorSetup = {
    Classes = {
        "CloseType_ForcedAuto", "OpenType_Manual",
        "Scanner_Hidden",
    },
    Sequence = {
        Type = "SingleDoor",
        Args = {1, 2, "PushDoorOpen", "PushDoorClose"}
    }
}

return DoorConfig.Build(Door)