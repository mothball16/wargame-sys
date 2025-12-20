local dir = require(script.Parent.Parent.Parent.Directory)
local levelOneAuth = require(script.Parent.AuthPrefabs.LevelOneAuth)

local openTime = 1
local holdTime = 2
local closeTime = 1


return {
    DoorRoot = {
        OpenCooldown = openTime + holdTime + closeTime
    },
    Scanner = {
        Template = "HiddenScanner",
        OnUseStrategy = "ScannerHiddenStrategy",
    },
    PartMover = {
        Use = "TweenMoveSequence",
        Instructions = {
            Front = {
                Door = {
                    [0] = {
                        to = "GoToFront",
                        info = {openTime, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut},
                        sound = {"PushDoorOpen"}
                    },
                    [openTime + holdTime] = {
                        to = "Orig",
                        info = {closeTime, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut},
                        sound = {"PushDoorClose"}
                    },
                },
            },
            Back = {
                Door = {
                    [0] = {
                        to = "GoToBack",
                        info = {openTime, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut},
                        sound = {"PushDoorOpen"}
                    },

                    [openTime + holdTime] = {
                        to = "Orig",
                        info = {closeTime, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut},
                        sound = {"PushDoorClose"}
                    },
                },
            }
        }
    }
}