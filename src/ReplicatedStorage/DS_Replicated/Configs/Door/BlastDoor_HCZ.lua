local Door = require(game.ReplicatedStorage.Shared.DS_Replicated.Configs.DoorConfig)
local _, Base = require(script.Parent.BlastDoor)

local BlastDoor: Door.DoorSetup = {
    Classes = {
        table.unpack(Base.Classes),
        "Auth_LevelFive",
        "CloseType_Auto"
    },
    Sequence = {
        Type = "DoubleDoor",
        Args = {3, 3, "BlastDoorOpen", "BlastDoorClose"}
    }
}

return Door.Build(BlastDoor), BlastDoor