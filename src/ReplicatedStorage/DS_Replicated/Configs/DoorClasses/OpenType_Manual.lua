local dir = require(game.ReplicatedStorage.Shared.DS_Replicated.Directory)
local Door = require(dir.Configs.DoorConfig)

local BehaviorAutoOpen: Door.DoorConfig = {
    Scanner = {
        OnMountStrategy = "ScannerManualMount",
        UseThrottle = 1
    },
}
return BehaviorAutoOpen