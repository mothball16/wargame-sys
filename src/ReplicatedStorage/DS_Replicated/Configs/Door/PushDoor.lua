local DoorConfig = require(game.ReplicatedStorage.Shared.DS_Replicated.Configs.DoorConfig)

local Door: DoorConfig.DoorSetup = {
    Classes = {
        "CloseType_ForcedAuto", "OpenType_Manual",
        "Scanner_Hidden",
    },
    Sequence = {
        Type = "SingleDirectionalDoor",
        Args = {1, 1, "PushDoorOpen", "PushDoorClose"}
    }
}

return {Build = DoorConfig.Build(Door), Raw = Door}