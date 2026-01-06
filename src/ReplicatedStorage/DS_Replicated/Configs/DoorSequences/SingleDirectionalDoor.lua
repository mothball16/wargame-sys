local dir = require(game.ReplicatedStorage.Shared.DS_Replicated.Directory)
local Door = require(dir.Configs.DoorConfig)

return function(openTime, closeTime, audioOpen, audioClose)
    audioOpen = type(audioOpen) == "table" and audioOpen or {audioOpen}
    audioClose = type(audioClose) == "table" and audioClose or {audioClose}

    local sequence: Door.DoorConfig = {
        PartMover = {
        Use = "TweenMoveSequence",
            Instructions = {
                Front = {
                    Open = {
                        Door = {
                            [0] = {
                                to = "GoToFront",
                                info = {openTime, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut},
                                sound = audioOpen
                            },
                        }
                    },
                    Close = {
                        Door = {
                            [0] = {
                                to = "Orig",
                                info = {closeTime, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut},
                                sound = audioClose
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
                                sound = audioOpen
                            },
                        }
                    },
                    Close = {
                        Door = {
                        [0] = {
                            to = "Orig",
                            info = {closeTime, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut},
                            sound = audioClose
                            },
                        }
                    },
                }
            }
        }
    }
    return sequence
end
