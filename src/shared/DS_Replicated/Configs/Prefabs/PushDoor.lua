local dir = require(script.Parent.Parent.Parent.Directory)
local auth = require(script.Parent.AuthPrefabs.LevelFiveAuth)
local Door = require(script.Parent.Parent.DoorConfig)

local openTime = 1
local holdTime = 2
local closeTime = 1

local config: Door.DoorConfig = {
    DoorRoot = {
        OpenCooldown = openTime + holdTime + closeTime
    },
    Scanner = {
        Template = "HiddenScanner",
        OnUseStrategy = "ScannerHiddenExecute"
    },
    PartMover = {
        Use = "TweenMoveSequence",
        Instructions = {
            Front = {
                Open = {
                    Door = {
                        [0] = {
                            to = "GoToFront",
                            info = {openTime, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut},
                            sound = {"PushDoorOpen"}
                        },
                    }
                },
                Close = {
                    Door = {
                        [0] = {
                            to = "Orig",
                            info = {closeTime, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut},
                            sound = {"PushDoorClose"}
                        },
                    }
                },
            },
            Back = {
                Open = {
                    Door = {
                        [0] = {
                            to = "GoToBack",
                            info = {openTime, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut},
                            sound = {"PushDoorOpen"}
                        },
                    }
                },
                Close = {
                    Door = {
                    [0] = {
                        to = "Orig",
                        info = {closeTime, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut},
                        sound = {"PushDoorClose"}
                        },
                    }
                },
            }
        }
    }
}

return dir.Helpers:TableCombineNew(auth, config)