local animid = animid.getgenv()
local Player = game:GetService("Players").LocalPlayer

-- Remove default Animate script
if Player.Character and Player.Character:FindFirstChild("Animate") then
	Player.Character.Animate:Destroy()
end

script.Name = "Animate"
script.Parent = Player.Character or Player.CharacterAdded:Wait()

-- Animation table
local tbl_upvr_3 = {
	idle = {{ id = "rbxassetid://12848629185"; weight = 10; }};
	walk = {{ id = "rbxassetid://12848633280"; weight = 10; }};
	run = {{ id = "rbxassetid://12848633280"; weight = 10; }};
	jump = {{ id = "rbxassetid://8325936827"; weight = 10; }};
	fall = {{ id = "rbxassetid://8325949769"; weight = 10; }};
	climb = {{ id = "rbxassetid://180436334"; weight = 10; }};
	sit = {{ id = "rbxassetid://8325946015"; weight = 10; }};
	wave = {{ id = "rbxassetid://128777973"; weight = 10; }};
	point = {{ id = "rbxassetid://128853357"; weight = 10; }};
}

-- Function to load animations
local function loadAnimation(humanoid, animData, name)
	local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)
	local animation = Instance.new("Animation")
	animation.AnimationId = animData[1].id
	animation.Name = name
	return animator:LoadAnimation(animation)
end

-- Setup animations
local function setupAnimations(character)
	local humanoid = character:WaitForChild("Humanoid")
	local animTracks = {}

	-- Load animations
	for animName, animData in pairs(tbl_upvr_3) do
		animTracks[animName] = loadAnimation(humanoid, animData, animName)
	end

	-- Current playing track
	local currentTrack = nil

	-- Helper to play one animation at a time
	local function playAnim(name)
		if currentTrack then
			currentTrack:Stop()
		end
		if animTracks[name] then
			currentTrack = animTracks[name]
			currentTrack:Play()
		end
	end

	-- Handle movement
	humanoid.Running:Connect(function(speed)
		if speed > 0 then
			if speed < 10 then
				playAnim("walk")
			else
				playAnim("run")
			end
		else
			playAnim("idle")
		end
	end)

	humanoid.Jumping:Connect(function()
		playAnim("jump")
	end)

	humanoid.StateChanged:Connect(function(_, newState)
		if newState == Enum.HumanoidStateType.Freefall then
			playAnim("fall")
		elseif newState == Enum.HumanoidStateType.Climbing then
			playAnim("climb")
		elseif newState == Enum.HumanoidStateType.Seated then
			playAnim("sit")
		end
	end)

	-- Idle default
	playAnim("idle")
end

-- Setup immediately if character exists
if Player.Character then
	setupAnimations(Player.Character)
end

-- Setup again when respawning
Player.CharacterAdded:Connect(setupAnimations)
