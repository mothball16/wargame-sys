local dir = require(game.ReplicatedStorage.Shared.DS_Replicated.Directory)
local Door = require(dir.Configs.DoorConfig)
local LockdownCheck = require(script.Parent.__LockdownCheck)

local AuthLevelFive: Door.DoorConfig = {
    Scanner = {
        ScanVisual = "LevelFive",
    },
    AuthChecks = {
        LockdownCheck,
        {"HoldingToolWithTag", {"LevelFive"}}
    }
}


return AuthLevelFive