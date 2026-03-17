local share =           game.ReplicatedStorage.m_Shared
local repl =            share.Doors

local root =            script.Parent
local mOS =             root.Parent._Main


return {
    Signals =           require(repl.Modules.Core.Signals),
    Main =              require(repl.Directory),
    mOS =               mOS,
    Repl =              repl,
    Root =              root,
}
