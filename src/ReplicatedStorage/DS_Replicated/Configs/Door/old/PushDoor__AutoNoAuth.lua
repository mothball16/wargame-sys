local dir = require(script.Parent.Parent.Parent.Directory)
local PushDoor = require(script.Parent.PushDoor)
local Door = require(script.Parent.Parent.DoorConfig)

return dir.Helpers:TableCombineNew(PushDoor, {
    DoorRoot = {
        CloseType = "ForcedAutoClose",
    },
    Scanner = {
        OnMountStrategy = "ScannerAutoMount",
        UseThrottle = 0
    },
})