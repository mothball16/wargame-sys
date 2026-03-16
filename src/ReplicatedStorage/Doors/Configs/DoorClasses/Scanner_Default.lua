local dir = require(game.ReplicatedStorage.mShared.Doors.Directory)
local Door = require(dir.Configs.DoorConfig)

local Class: Door.DoorConfig = {
    Scanner = {
        Template = "DefaultScanner",
        OnUseStrategy = "ScannerPortalExecute"
    },
}
return Class