local dir = require(game.ReplicatedStorage.Shared.DS_Replicated.Directory)
local Door = require(dir.Configs.DoorConfig)
local LockdownCheck = require(script.Parent.__LockdownCheck)

local Class: Door.DoorConfig = {
    Scanner = {
        ScanVisual = "LevelOne",
    },
    AuthChecks = {
        LockdownCheck,
        {"OR", {
            {"HasToolWithTag", {"LevelOne"}},
        }}
    }
}

return Class