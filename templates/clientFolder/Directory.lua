local share =           game.ReplicatedStorage.Shared
local repl --[[= (share.mAS_Replicated) <- replace this with repl folder]]

local root =            script.Parent
local mOS =             root.Parent.mOS_Client


return {
    Signals =           require(repl.Modules.Core.Signals),
    Main =              require(repl.Directory),
    mOS =               mOS,
    Repl =              repl,
    Root =              root,
}
