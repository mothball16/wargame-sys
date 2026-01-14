local dir = require(game.ReplicatedStorage.Shared.DS_Replicated.Directory)
local Door = require(dir.Configs.DoorConfig)

local Class: Door.DoorConfig = {
    DoorRoot = {
        CloseType = "ForcedAutoClose",
    },
}
return Class