local dir = require(script.Parent.Parent.Parent.Directory)
local Base = require(script.Parent.BlastDoor)


return dir.Helpers:TableCombineNew(Base, {
    DoorRoot = {
        CloseType = "AutoClose"
    }
})