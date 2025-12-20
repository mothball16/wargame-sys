local dir = require(script.Parent.Parent.Parent.Directory)
local Base = require(script.Parent.BlastDoor)
local LockedAuth = require(script.Parent.AuthPrefabs.LockedAuth)

return dir.Helpers:TableCombineNew(Base, LockedAuth)