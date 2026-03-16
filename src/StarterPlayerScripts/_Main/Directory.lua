local share =           game.ReplicatedStorage.mShared
local repl =            share._Main
local utility =         share.mOS_Utility

local root =            script.Parent
local mOS =             root.Parent._Main


return {
    mOS =               mOS,
    Repl =              repl,
    Root =              root,
    Utility =           utility,
    Main =              require(repl.Directory)
}
