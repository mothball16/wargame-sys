local dir = require(game.ReplicatedStorage.Shared.DS_Replicated.Directory)
local Door = require(dir.Configs.DoorConfig)

local BehaviorDoorClipsDuringAnim: Door.DoorConfig = {
    DoorRoot = {
        DoorClipsDuringAnim = false
    },
}
return BehaviorDoorClipsDuringAnim