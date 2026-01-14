local dir = require(game.ReplicatedStorage.Shared.DS_Replicated.Directory)
local Door = require(dir.Configs.DoorConfig)

local Class: Door.DoorConfig = {
    Scanner = {
        OnMountStrategy = "ScannerAutoMount",
        UseThrottle = 0
    },
}
return Class