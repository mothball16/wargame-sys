-- "borrowed" from Not_Fanbox

local RS = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local DistFunctions = {
	[Enum.FieldOfViewMode.Vertical.Name] = function()
		return Camera.ViewportSize.Y, Camera.FieldOfView
	end,
	[Enum.FieldOfViewMode.Diagonal.Name] = function()
		return Camera.ViewportSize.Magnitude, Camera.DiagonalFieldOfView
	end,
	[Enum.FieldOfViewMode.MaxAxis.Name] = function()
		local vp = Camera.ViewportSize
		return math.max(vp.X, vp.Y), Camera.MaxAxisFieldOfView
	end,
}

local BEAM_COUNT  = 3
local PIXEL_SIZE  = 2.5

local EstimatedThreads = 0
local module = {}

module.New = function(Bullet, Color, Width, Life, LightEmit, LightInf, FullTracer, Texture)
	EstimatedThreads += 1
	Width = Width * 0.5

	local textureId = Texture or "rbxassetid://232918622"

	local pairsData = {}
	local allBeams  = {}

	for i = 1, BEAM_COUNT do
		local Att1 = Instance.new("Attachment")
		Att1.Name = "TracerA1_" .. i
		local Att2 = Instance.new("Attachment")
		Att2.Name = "TracerA2_" .. i

		local Trail = Instance.new("Trail")
		if FullTracer then
			Trail.Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.2),
				NumberSequenceKeypoint.new(1, 0.2),
			})
			Trail.WidthScale = NumberSequence.new({
				NumberSequenceKeypoint.new(0,    0.5),
				NumberSequenceKeypoint.new(0.25, 1),
				NumberSequenceKeypoint.new(0.75, 1),
				NumberSequenceKeypoint.new(1,    0.5),
			})
		else
			Trail.Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.2),
				NumberSequenceKeypoint.new(1, 1),
			})
			Trail.WidthScale = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 1),
				NumberSequenceKeypoint.new(1, 0.5),
			})
		end
		Trail.Texture        = textureId
		Trail.TextureMode    = Enum.TextureMode.Stretch
		Trail.Color          = Color
		Trail.FaceCamera     = false
		Trail.LightEmission  = LightEmit
		Trail.LightInfluence = LightInf
		Trail.Brightness     = 2
		Trail.Lifetime       = Life
		Trail.Attachment0    = Att1
		Trail.Attachment1    = Att2

		local Beam = Instance.new("Beam")
		Beam.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.2),
			NumberSequenceKeypoint.new(1, 0.2),
		})
		Beam.Texture        = textureId
		Beam.TextureMode    = Enum.TextureMode.Stretch
		Beam.Color          = Color
		Beam.TextureSpeed   = 0
		Beam:SetTextureOffset(0)
		Beam.FaceCamera     = false
		Beam.LightEmission  = LightEmit
		Beam.LightInfluence = LightInf
		Beam.Brightness     = 2
		Beam.Attachment0    = Att1
		Beam.Attachment1    = Att2
		Beam.Width0         = Width * 2
		Beam.Width1         = Width * 2
		Beam.Enabled        = false

		Att1.Parent  = Bullet
		Att2.Parent  = Bullet
		Trail.Parent = Bullet
		Beam.Parent  = Bullet

		pairsData[i] = { Att1, Att2 }
		allBeams[i]  = Beam
	end

	task.defer(function()
		repeat RS.RenderStepped:Wait()
		until not Bullet or (Bullet.Position - Camera.CFrame.Position).Magnitude > 5
		for _, b in allBeams do b.Enabled = true end
	end)

	local con
	con = RS.RenderStepped:Connect(function()
		if not (Bullet and Bullet:IsDescendantOf(workspace)) then
			EstimatedThreads -= 1
			con:Disconnect()
			return
		end

		local bulletPos  = Bullet.Position
		local camPos     = Camera.CFrame.Position
		local diff       = camPos - bulletPos
		local dist       = diff.Magnitude
		if dist < 0.001 then return end

		local pixels, fov = DistFunctions[Camera.FieldOfViewMode.Name]()
		local tanHalfFov  = math.tan(math.rad(fov * 0.5))
		local NW          = PIXEL_SIZE * dist * 2 * tanHalfFov / pixels

		local toCam  = diff / dist
		local worldUp = Vector3.new(0, 1, 0)
		if math.abs(toCam:Dot(worldUp)) > 0.98 then
			worldUp = Vector3.new(1, 0, 0)
		end
		local right  = toCam:Cross(worldUp).Unit
		local upPerp = right:Cross(toCam).Unit

		local step = math.pi / BEAM_COUNT
		for i, pair in ipairs(pairsData) do
			local angle  = (i - 1) * step
			local offset = (right * math.cos(angle) + upPerp * math.sin(angle)) * NW
			pair[1].Position   =  offset
			pair[2].Position   = -offset
			allBeams[i].Width0 = NW * 2
			allBeams[i].Width1 = NW * 2
		end
	end)
end

module.GetThreads = function()
	return EstimatedThreads
end

return module