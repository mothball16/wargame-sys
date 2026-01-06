local dir = require(game.ReplicatedStorage.Shared.DS_Replicated.Directory)
local Door = require(dir.Configs.DoorConfig)

local AutoClose: Door.DoorConfig = {
    DoorRoot = {
        CloseType = "AutoClose",
    },
}
return AutoClose