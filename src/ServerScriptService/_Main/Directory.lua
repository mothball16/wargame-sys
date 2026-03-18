local share =           game.ReplicatedStorage.m_Shared
local repl =            share._Main

local root =            script.Parent
local mOS =             root.Parent._Main

return {
    mOS =               mOS,
    Repl =              repl,
    Root =              root,
    Modules =           root.Modules,
    Main =              require(repl.Directory)
}
