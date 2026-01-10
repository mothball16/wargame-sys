local DoorConfig = require(game.ReplicatedStorage.Shared.DS_Replicated.Configs.DoorConfig)
local Base = require(script.Parent.BlastDoor).Raw

local Door: DoorConfig.DoorSetup = {
    Classes = {
        "Auth_LevelFive",
        "Scanner_RFID",
        "CloseType_Auto"
    },
    Sequence = {
        Type = "DoubleDoor",
        Args = {3, 3, "BlastDoorOpen", "BlastDoorClose"}
    }
}

-- TODO: make this less bad..
for _, v in pairs(Base.Classes) do
    table.insert(Door.Classes, 1, v)
end

return DoorConfig.Build(Door)