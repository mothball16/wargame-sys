local dir = require(game.ReplicatedStorage.mShared.Doors.Directory)
local Door = require(dir.Configs.DoorConfig)

local Class: Door.DoorConfig = {
    Scanner = {
        OnMountStrategy = "ScannerManualMount",
        UseThrottle = 1
    },
}
return Class