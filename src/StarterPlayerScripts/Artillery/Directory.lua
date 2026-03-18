local share =           game.ReplicatedStorage.m_Shared
local repl =            share.Artillery

local root =            script.Parent
local mOS =             root.Parent._Main


return {
    Signals =           require(repl.Modules.Core.Signals),
    Main =              require(repl.Directory),
    Types =             require(root.Types),
    mOS =               mOS,
    Repl =              repl,
    Root =              root,
    Modules =           root.Modules,

    Options = {
        Joystick = {
            path = repl.Modules.Joystick,
            default = "MouseBasedJoystick"
        },
        UIHandler = {
            root.Modules.UIHandlers,
            default = "MLRS_UIHandler"
        },
    }
}
