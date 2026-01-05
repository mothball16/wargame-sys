local Door = require(script.Parent.Parent.DoorConfig)
local dir = require(script.Parent.Parent.Parent.Directory)
local levelOneAuth = require(script.Parent.AuthPrefabs.LevelOneAuth)

local openTime, closeTime = 3, 3

local config: Door.DoorConfig = {
    DoorRoot = {
        DisableCollisionOnOpen = false,
        CloseType = "ManualClose",
    },
    Scanner = {
        OnMountStrategy = "ScannerManualMount",
        OnUseStrategy = "ScannerPortalExecute",
    },
    PartMover = {
        Use = "TweenMoveSequence",
        Instructions = {
            Default = {
                Open = {
                    Door1 = {
                        [0] = {
                            to = "GoTo",
                            info = {openTime, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut},
                            sound = {"BlastDoorOpen"}
                        },
                    },
                    Door2 = {
                        [0] = {
                            to = "GoTo",
                            info = {openTime, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut},
                            sound = {"BlastDoorOpen"}
                        },
                    }
                },
                Close = {
                    Door1 = {
                        [0] = {
                            to = "Orig",
                            info = {closeTime, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut},
                            sound = {"BlastDoorClose"}
                        },
                    },
                    Door2 = {
                        [0] = {
                            to = "Orig",
                            info = {closeTime, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut},
                            sound = {"BlastDoorClose"}
                        },
                    }
                }
            }
        }
    }
}

return dir.Helpers:TableCombineNew(levelOneAuth, config)
