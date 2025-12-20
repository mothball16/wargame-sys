local share =           game.ReplicatedStorage.Shared
local repl =            share.DS_Replicated

local root =            script.Parent
local mOS =             root.Parent.mOS_Server

return {
    mOS =               mOS,
    Repl =              repl,
    Root =              root,
    Main =              require(repl.Directory)
}
