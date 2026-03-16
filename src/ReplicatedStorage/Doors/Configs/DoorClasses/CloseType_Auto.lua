local dir = require(game.ReplicatedStorage.mShared.Doors.Directory)
local Door = require(dir.Configs.DoorConfig)

local Class: Door.DoorConfig = {
    DoorRoot = {
        CloseType = "AutoClose",
        AutoCloseSeconds = 3
    },
}
return Class