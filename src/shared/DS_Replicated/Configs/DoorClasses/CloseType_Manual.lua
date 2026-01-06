local dir = require(game.ReplicatedStorage.Shared.DS_Replicated.Directory)
local Door = require(dir.Configs.DoorConfig)

local ManualClose: Door.DoorConfig = {
    DoorRoot = {
        CloseType = "ManualClose",
    },
}
return ManualClose