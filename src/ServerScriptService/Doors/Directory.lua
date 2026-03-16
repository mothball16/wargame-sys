local share =           game.ReplicatedStorage.mShared
local repl =            share.Doors

local root =            script.Parent
local mOS =             root.Parent._Main

return {
    mOS =               mOS,
    Repl =              repl,
    Root =              root,
    Modules =           root.Modules,
    Main =              require(repl.Directory),
    ServerSignals =     require(root.Modules.ServerSignals),

}
