local Signal = require(game.ReplicatedStorage.mShared.mOS_Utility.Signal)
return {
    OnDoorCreated = Signal.new();
    OnDoorDestroyed = Signal.new();
    --OnLockdownUpdated = Signal.new();
}