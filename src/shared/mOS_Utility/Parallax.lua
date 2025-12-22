--[[
parallax script from Roblox's portal with edits cause it wasnt working
for some stuff

Edit: So i realized it wasnt working because i accidentally double-welded
the prompt with one having a rotation offset. I still finished this tho so whateva.
]]

local Parallax = {}
Parallax.__index = Parallax


function Parallax.new(instance)
	local self = setmetatable({}, Parallax)
	self.layers = {}
	self.portal = instance
	self.portalGui = instance.PortalGui.Portal

	for _, layer in self.portalGui:GetChildren() do
		self:AddLayer(layer)
	end
	return self
end

function Parallax:AddLayer(layer)
	self.layers[layer] = {
		x = layer:GetAttribute("X") or 0.5,
		y = layer:GetAttribute("Y") or 0.5,
		depth = layer:GetAttribute("ParallaxDepth") or 0,
	}
end

-- TODO: support things other than squares : P
function Parallax:Update()
	local cam = game.Workspace.CurrentCamera
	if not cam then return end

	-- get the global diff between cam and portal
	local camDiff = (self.portal.Position - cam.CFrame.Position).Unit
	-- map the diff onto the portal orientation
	local localDiff = self.portal.CFrame:VectorToObjectSpace(camDiff)

	for instance, layerInfo in self.layers do
		local shiftX = localDiff.X * layerInfo.depth
		local shiftY = localDiff.Y * layerInfo.depth

		instance.Position = UDim2.fromScale(layerInfo.x + shiftX, layerInfo.y + shiftY)
	end
end

function Parallax:Destroy()
	
end

return Parallax