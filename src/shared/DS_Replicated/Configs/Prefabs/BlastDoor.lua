local dir = require(script.Parent.Parent.Parent.Directory)
local levelOneAuth = require(script.Parent.AuthPrefabs.LevelOneAuth)

local openTime = 3
local holdTime = 3
local closeTime = 4.7
local cdPadding = 1


return dir.Helpers:TableCombineNew(levelOneAuth, {
    DoorRoot = {
        DisableCollisionOnOpen = false,
        OpenCooldown = openTime + holdTime + closeTime + cdPadding
    },
    Scanner = {
        OnUseStrategy = "ScannerPortalStrategy",
    },
    PartMover = {
        Use = "TweenMoveSequence",
        Instructions = {
            Default = {
                Door1 = {
                    [0] = {
                        to = "GoTo",
                        info = {openTime, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut},
                        sound = {"BlastDoorOpen"}
                    },
                    [openTime + holdTime] = {
                        to = "Orig",
                        info = {closeTime, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut},
                        sound = {"BlastDoorClose"}
                    },
                },
                Door2 = {
                    [0] = {
                        to = "GoTo",
                        info = {openTime, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut},
                        sound = {"BlastDoorOpen"}
                    },
                    [openTime + holdTime] = {
                        to = "Orig",
                        info = {closeTime, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut},
                        sound = {"BlastDoorClose"}
                    },
                }
            }
        }
    }
})