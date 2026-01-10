local DoorConfig = require(game.ReplicatedStorage.Shared.DS_Replicated.Configs.DoorConfig)
local Base = require(script.Parent.BlastDoor).Raw

local Door: DoorConfig.DoorSetup = {
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

return {Build = DoorConfig.Build(Door), Raw = Door}