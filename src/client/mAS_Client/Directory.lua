local share =           game.ReplicatedStorage.Shared
local repl =            share.mAS_Replicated

local root =            script.Parent
local mOS =             root.Parent.mOS_Client


return {
    Signals =           require(repl.Modules.Core.Signals),
    Main =              require(repl.Directory),
    mOS =               mOS,
    Repl =              repl,
    Root =              root,
}
