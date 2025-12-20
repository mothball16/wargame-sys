local dir = require(script.Parent.Parent.Parent.Directory)

local openTime = 1
local holdTime = 2
local closeTime = 1


return {
    DoorRoot = {
        OpenCooldown = openTime + holdTime + closeTime
    },
    Scanner = {
        Template = "HiddenScanner",
        OnMountStrategy = "ScannerAutoMount",
        OnUseStrategy = "ScannerHiddenExecute",
       -- DisplayPrompt = false,
        UseThrottle = 0
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