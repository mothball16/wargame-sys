local dir = require(game.ReplicatedStorage.mShared.Doors.Directory)
local Door = require(dir.Configs.DoorConfig)

local Class: Door.DoorConfig = {
    DoorRoot = {
        ["InitialState"] = "Open"
    },
}
return Class