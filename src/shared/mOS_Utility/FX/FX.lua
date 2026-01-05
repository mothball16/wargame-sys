local FXActivator = require(script.Parent.FXActivator)
local FXCreator = require(script.Parent.FXCreator)
local FXPreserve = require(script.Parent.FXPreserve)

--[[
Activate - plays particles from an EXISTING object. can play any particle
Create - plays a particle bundle at a location, not an existing object. can only play from assets
Preserve - intercepts and reparents particle holders right before destruction
]]
return {
    Activate = FXActivator,
    Create = FXCreator,
    Preserve = FXPreserve
}