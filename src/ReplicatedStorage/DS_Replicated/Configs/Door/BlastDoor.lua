local Door = require(game.ReplicatedStorage.Shared.DS_Replicated.Configs.DoorConfig)

local BlastDoor: Door.DoorSetup = {
    Classes = {
        "Auth_LevelOne",
        "CloseType_Manual", "OpenType_Manual",

        "Scanner_RFID",
        "Behavior_DoorClipsDuringAnim",
    },
    Sequence = {
        Type = "DoubleDoor",
        Args = {3, 3, "BlastDoorOpen", "BlastDoorClose"}
    }
}

return Door.Build(BlastDoor)