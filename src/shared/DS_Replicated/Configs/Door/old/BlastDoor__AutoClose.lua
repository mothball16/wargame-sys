local dir = require(game.ReplicatedStorage.Shared.DS_Replicated.Directory)
local Base = require(script.Parent.BlastDoor)


return dir.Helpers:TableCombineNew(Base, {
    DoorRoot = {
        CloseType = "AutoClose"
    }
})