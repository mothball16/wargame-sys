local dir = require(game.ReplicatedStorage.Shared.DS_Replicated.Directory)
local Base = require(script.Parent.PushDoor)
local Door = require(dir.Configs.DoorConfig)
local Auth = require(dir.Configs.Prefabs.AuthPrefabs.LevelOneAuth)

return dir.Helpers:TableCombineNew(Base, auth, {
    DoorRoot = {
        CloseType = "ForcedAutoClose",
    },
    Scanner = {
        OnMountStrategy = "ScannerAutoMount",
        UseThrottle = 0
    },
})