local Signal = require(game.ReplicatedStorage.Shared.mOS_Utility.Signal)
return {
    OnDoorCreated = Signal.new();
    OnDoorDestroyed = Signal.new();
    --OnLockdownUpdated = Signal.new();
}