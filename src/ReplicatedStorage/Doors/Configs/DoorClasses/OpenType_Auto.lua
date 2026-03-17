local dir = require(game.ReplicatedStorage.m_Shared.Doors.Directory)
local Door = require(dir.Configs.DoorConfig)

local Class: Door.DoorConfig = {
    Scanner = {
        OnMountStrategy = "ScannerAutoMount",
        UseThrottle = 0
    },
}
return Class