local share =           game.ReplicatedStorage.m_Shared
local repl =            share._Main
local utility =         share._Utilities

local root =            script.Parent
local mOS =             root.Parent._Main


return {
    mOS =               mOS,
    Repl =              repl,
    Root =              root,
    Utility =           utility,
    Main =              require(repl.Directory)
}
