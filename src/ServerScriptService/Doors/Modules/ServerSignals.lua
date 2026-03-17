local Signal = require(game.ReplicatedStorage.m_Shared._Utilities.Signal)
return {
    OnDoorCreated = Signal.new();
    OnDoorDestroyed = Signal.new();
    --OnLockdownUpdated = Signal.new();
}