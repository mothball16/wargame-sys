--#region required
local dir = require(script.Parent.Parent.Parent.Directory)
--#endregion required
--[[
activates particles on an ALREADY EXISTING object on the server
if the object isn't on the server, use FXCreator instead
]]

local FXActivator = {}

local fallbacks = {
	["delay"] = 0,
	["lookFor"] = "FXEmit",
	["playFor"] = 1,
	["avoidDestruction"] = false
}


local function FireFX(persistent, config, FXHolder)
	-- if the thing being activated is about to be destroyed (onHit particles, bla bla)
	-- then eject particles from the model so that they arent destroyed : o
	if config["avoidDestruction"] then
		FXHolder = FXHolder:Clone()
		FXHolder.Parent = game.Workspace.IgnoreList
		FXHolder.Anchored = true
		FXHolder.CanCollide = false
		FXHolder.CanQuery = false
	end
	-- particles should always be clientside
	local shouldShowEmitters = not dir.isServer
	
	-- server-side audio is OK AFAIK. but only if the call originated from the server so that a client doesnt double play the audio
	-- HOLY SHIT I USED NOT XOR!!
	local shouldPlayAudio = dir.isServer == config.serverIsOrigin --(dir.isServer and config.serverIsOrigin) or (not dir.isServer and not config.serverIsOrigin)

	local maxEmitLength = 0
	for _, fx in pairs(FXHolder:GetChildren()) do
		local isEmitter = fx:IsA("ParticleEmitter") or fx:IsA("Trail") or fx:IsA("Beam") or fx:IsA("Smoke")
		local emitLength = fx:GetAttribute("PlayFor") or config["playFor"]
		local delayLength = fx:GetAttribute("Delay") or config["delay"]
		maxEmitLength = math.max(maxEmitLength, emitLength)

		-- TODO: fix Ts.
		task.delay(delayLength, function()
			if isEmitter and shouldShowEmitters then
				fx.Enabled = true
				task.delay(emitLength, function()
					fx.Enabled = false
				end)
			elseif fx:IsA("Sound") and shouldPlayAudio then
				fx.TimePosition = 0
				fx:Play()
				if (fx :: Sound).Looped then
					table.insert(persistent, fx)
				end
			end
		end)
	end

	if config["avoidDestruction"] then
		game.Debris:AddItem(FXHolder, 30 + maxEmitLength)
	end
end

function FXActivator:ExecuteOnClient(config, args)
	local persistent = {}
	config = dir.Helpers:TableOverwrite(fallbacks, config)
	print(config)
	for _, holder in pairs(args.object:GetChildren()) do
		if holder.Name == config["lookFor"] then
			FireFX(persistent, config, holder, false)
		end
	end
	return persistent
end

--[[
particles are not played on the server (Bad!!)
this just ticks the avoidDestruction so particles aren't prematurely deleted
and also tells other clients to replicate

```
local FX = require(dir.Utility.FX.FX)
local fxFolder = script.fxFolder.Value
-- activates the FX on a part from the server
FX.Activate:ExecuteOnServer(nil, nil, {object = fxFolder})

]]
function FXActivator:ExecuteOnServer(plr, config, args)
	local persistent = {}
	config = dir.Helpers:TableOverwrite(fallbacks, config)
	config.serverIsOrigin = plr == nil

	-- accessible from the server, just run it on that
	for _, holder in pairs(args.object:GetChildren()) do
		if holder.Name == config["lookFor"] then
			FireFX(persistent, config, holder)
		end
	end
	dir.NetUtils:FireOtherClients(plr, dir.Events.Reliable.OnParticlePlayed, config, args)
	return persistent
end


return FXActivator