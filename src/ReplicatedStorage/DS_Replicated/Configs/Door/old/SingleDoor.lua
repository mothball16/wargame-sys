local Door = require(script.Parent.Parent.DoorConfig)
local dir = require(script.Parent.Parent.Parent.Directory)
local levelOneAuth = require(script.Parent.AuthPrefabs.LevelOneAuth)

local openTime, closeTime = 3, 3

local config: Door.DoorConfig = {
    DoorRoot = {
        DoorClipsDuringAnim = true,
        CloseType = "ForcedAutoClose",
    },
    Scanner = {
        Template = "HiddenScanner",
        OnMountStrategy = "ScannerManualMount",
        OnUseStrategy = "ScannerHiddenExecute",
    },
    PartMover = {
        Use = "TweenMoveSequence",
        Instructions = {
            Default = {
                Open = {
                    Door = {
                        [0] = {
                            to = "GoTo",
                            info = {openTime, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut},
                            sound = {"BlastDoorOpen"}
                        },
                    },
                    
                },
                Close = {
                    Door = {
                        [0] = {
                            to = "Orig",
                            info = {closeTime, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut},
                            sound = {"BlastDoorClose"}
                        },
                    },
                }
            }
        }
    }
}

return dir.Helpers:TableCombineNew(levelOneAuth, config)
