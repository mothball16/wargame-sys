local share =           game.ReplicatedStorage.m_Shared
local repl --[[= (share.Artillery) <- replace this with repl folder]]

local root =            script.Parent
local mOS =             root.Parent._Main


return {
    Signals =           require(repl.Modules.Core.Signals),
    Main =              require(repl.Directory),
    mOS =               mOS,
    Repl =              repl,
    Root =              root,
}
