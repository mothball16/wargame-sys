local Door = require(game.ReplicatedStorage.Shared.DS_Replicated.Configs.DoorConfig)

local PushDoor: Door.DoorSetup = {
    Classes = {
        "CloseType_ForcedAuto", "OpenType_Manual",
        "Scanner_Hidden",
    },
    Sequence = {
        Type = "SingleDirectionalDoor",
        Args = {1, 1, "PushDoorOpen", "PushDoorClose"}
    }
}

return Door.Build(PushDoor), PushDoor