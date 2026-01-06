local share =           game.ReplicatedStorage.Shared
local repl =            share.mGS_Replicated

local root =            script.Parent
local mOS =             root.Parent.mOS_Client


return {
    Main =              require(repl.Directory),
    mOS =               mOS,
    Repl =              repl,
    Root =              root,
}
