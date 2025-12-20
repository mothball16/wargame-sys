--#region requires
local dirClient = require(script.Parent.Parent.Parent.Directory)
local dir = dirClient.Main
local validator = dir.Validator.new(script.Name)
--#endregion

--[[
picks up shit that just re-routes the client event back to the behavior module.
to find behavior look in the behavior module itself, this just wires it up
]]

local ReplicationRouter = {}

function ReplicationRouter:RouteSingle(evtName, behavior)
    validator:Exists(behavior.ExecuteOnClient, "ExecuteOnClient func of behavior")
    dir.Net:Connect(evtName, function(config, ...)
        behavior:ExecuteOnClient(config, ...)
    end)
end

--[[
[1] the event STRING, [2] the required modulescript that adheres to behavior contract
```
ReplicationRouter:Route({
    {dir.Events.Reliable.OnParticleCreated, FX.Create},
    {dir.Events.Reliable.OnParticlePlayed, FX.Activate},
    {dir.Events.Reliable.OnShake, GoShake},
})
```
]]
function ReplicationRouter:Route(connections)
    for _, cmd in pairs(connections) do
        self:RouteSingle(cmd[1], cmd[2])
    end
end

return ReplicationRouter