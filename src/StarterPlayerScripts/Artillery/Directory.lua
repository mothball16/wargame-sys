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
}
