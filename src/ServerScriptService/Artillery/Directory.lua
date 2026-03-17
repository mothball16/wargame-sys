local share =           game.ReplicatedStorage.m_Shared
local repl =            share.Artillery

local root =            script.Parent
local mOS =             root.Parent._Main

return {
    mOS =               mOS,
    Repl =              repl,
    Root =              root,
    Main =              require(repl.Directory)
}
