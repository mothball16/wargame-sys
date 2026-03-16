local Signal = require(game.ReplicatedStorage.mShared._Utilities.Signal)
return {
    OnDoorCreated = Signal.new();
    OnDoorDestroyed = Signal.new();
    --OnLockdownUpdated = Signal.new();
}