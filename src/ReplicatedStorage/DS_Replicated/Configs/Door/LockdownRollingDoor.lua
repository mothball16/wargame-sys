local DoorConfig = require(game.ReplicatedStorage.Shared.DS_Replicated.Configs.DoorConfig)

local Door: DoorConfig.DoorSetup = {
    Classes = {
        "Auth_LevelFive",
        "CloseType_Manual", "OpenType_Manual",
        "Scanner_Hidden",
        "InitialState_Opened",
        "Behavior_DoorClipsDuringAnim",
        "LockdownControl_Strict",
    },
    Sequence = {
        Type = "SingleDoor",
        Args = {4, 2, "BlastDoorOpen", "BlastDoorClose"}
    }
}

return DoorConfig.Build(Door)