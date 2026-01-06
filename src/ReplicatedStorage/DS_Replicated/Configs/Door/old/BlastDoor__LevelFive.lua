local dir = require(game.ReplicatedStorage.Shared.DS_Replicated.Directory)

local Base = require(script.Parent.BlastDoor)
local auth = require(dir.Configs.Prefabs.AuthPrefabs.LevelFiveAuth)

return dir.Helpers:TableCombineNew(Base, auth)