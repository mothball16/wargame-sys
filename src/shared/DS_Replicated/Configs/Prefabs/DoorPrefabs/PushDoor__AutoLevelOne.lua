local dir = require(script.Parent.Parent.Parent.Directory)
local auth = require(script.Parent.AuthPrefabs.LevelOneAuth)
local PushDoor = require(script.Parent.PushDoor)
local Door = require(script.Parent.Parent.DoorConfig)


return dir.Helpers:TableCombineNew(PushDoor, auth, {
    DoorRoot = {
        CloseType = "ForcedAutoClose",
    },
    Scanner = {
        OnMountStrategy = "ScannerAutoMount",
        UseThrottle = 0
    },
})