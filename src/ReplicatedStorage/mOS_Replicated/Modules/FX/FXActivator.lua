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
	local cleanupTarget = FXHolder

	-- if the thing being activated is about to be destroyed (onHit particles, bla bla)
	-- then eject particles from the model so that they arent destroyed : o
	if config["avoidDestruction"] then
		local originalHolder = FXHolder
		FXHolder = originalHolder:Clone()
		
		if FXHolder:IsA("Attachment") then
			local proxyPart = Instance.new("Part")
			proxyPart.Name = "FXProxy"
			proxyPart.Transparency = 1
			proxyPart.Anchored = true
			proxyPart.CanCollide = false
			proxyPart.CanQuery = false
			proxyPart.Size = Vector3.new(0.1, 0.1, 0.1)
			proxyPart.CFrame = originalHolder.WorldCFrame
			proxyPart.Parent = game.Workspace.IgnoreList
			
			FXHolder.Parent = proxyPart
			cleanupTarget = proxyPart
		else
			FXHolder.Parent = game.Workspace.IgnoreList
			if FXHolder:IsA("BasePart") then
				FXHolder.Anchored = true
				FXHolder.CanCollide = false
				FXHolder.CanQuery = false
			end
			cleanupTarget = FXHolder
		end
	end

	local maxEmitLength = 0
	for _, fx in pairs(FXHolder:GetChildren()) do
		local isEmitter = fx:IsA("ParticleEmitter") or fx:IsA("Trail") or fx:IsA("Beam") or fx:IsA("Smoke")
		local emitLength = fx:GetAttribute("PlayFor") or config["playFor"]
		local delayLength = fx:GetAttribute("Delay") or config["delay"]
		maxEmitLength = math.max(maxEmitLength, emitLength)

		local function playFX()
			if isEmitter then
				fx.Enabled = true
				task.delay(emitLength, function()
					fx.Enabled = false
				end)
			elseif fx:IsA("Sound") then
				fx.TimePosition = 0
				fx:Play()
				if fx.Looped then
					table.insert(persistent, fx)
				end
			end
		end

		if delayLength > 0 then
			task.delay(delayLength, playFX)
		else
			playFX()
		end
	end

	if config["avoidDestruction"] then
		game.Debris:AddItem(cleanupTarget, 30 + maxEmitLength)
	end
end

function FXActivator:ExecuteOnClient(config, args)
	local persistent = {}
	if not args or not args.object or not args.object.Parent then return persistent end

	config = dir.Helpers:TableOverwrite(fallbacks, config)
	for _, holder in pairs(args.object:GetChildren()) do
		if holder.Name == config["lookFor"] then
			FireFX(persistent, config, holder)
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