local share =           game.ReplicatedStorage.Shared
local repl =            share.DS_Replicated

local root =            script.Parent
local mOS =             root.Parent.mOS_Server

return {
    mOS =               mOS,
    Repl =              repl,
    Root =              root,
    Modules =           root.Modules,
    Main =              require(repl.Directory),
    ServerSignals =     require(root.Modules.ServerSignals),

}
