local dir = require(game.ReplicatedStorage.Shared.DS_Replicated.Directory)
local Door = require(dir.Configs.DoorConfig)

return function(openTime, closeTime, audioOpen, audioClose)
    audioOpen = type(audioOpen) == "table" and audioOpen or {audioOpen}
    audioClose = type(audioClose) == "table" and audioClose or {audioClose}

    local sequence: Door.DoorConfig = {
        PartMover = {
            Use = "TweenMoveSequence",
            Instructions = {
                Default = {
                    Open = {
                        Door1 = {
                            [0] = {
                                to = "GoTo",
                                info = {openTime, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut},
                                sound = audioOpen
                            },
                        },
                        Door2 = {
                            [0] = {
                                to = "GoTo",
                                info = {openTime, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut},
                                sound = audioOpen
                            },
                        }
                    },
                    Close = {
                        Door1 = {
                            [0] = {
                                to = "Orig",
                                info = {closeTime, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut},
                                sound = audioClose
                            },
                        },
                        Door2 = {
                            [0] = {
                                to = "Orig",
                                info = {closeTime, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut},
                                sound = audioClose
                            },
                        }
                    }
                }
            }
        }
    }
    return sequence
end
