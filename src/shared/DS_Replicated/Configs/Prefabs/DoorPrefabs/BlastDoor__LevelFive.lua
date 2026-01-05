local dir = require(script.Parent.Parent.Parent.Directory)
local Base = require(script.Parent.BlastDoor)
local auth = require(script.Parent.AuthPrefabs.LevelFiveAuth)

return dir.Helpers:TableCombineNew(Base, auth)