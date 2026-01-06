local dir = require(game.ReplicatedStorage.Shared.DS_Replicated.Directory)
local Door = require(dir.Configs.DoorConfig)

local BehaviorAutoOpen: Door.DoorConfig = {
    Scanner = {
        OnMountStrategy = "ScannerAutoMount",
        UseThrottle = 0
    },
}
return BehaviorAutoOpen