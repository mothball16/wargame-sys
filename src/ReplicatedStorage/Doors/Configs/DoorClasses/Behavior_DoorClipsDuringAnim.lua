local dir = require(game.ReplicatedStorage.m_Shared.Doors.Directory)
local Door = require(dir.Configs.DoorConfig)

local Class: Door.DoorConfig = {
    DoorRoot = {
        DoorClipsDuringAnim = true
    },
}
return Class

