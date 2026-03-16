local Signal = require(game.ReplicatedStorage.mShared.mOS_Utility.Signal)
return {
    InitObject = Signal.new();
    DestroyObject = Signal.new();
}