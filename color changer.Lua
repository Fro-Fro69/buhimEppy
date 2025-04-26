local Player = game:GetService("Players").LocalPlayer
local HRP

-- Update HRP on character spawn
local function onCharacterAdded(character)
	HRP = character:WaitForChild("HumanoidRootPart")
end

if Player.Character then
	onCharacterAdded(Player.Character)
end

Player.CharacterAdded:Connect(onCharacterAdded)

-- Load Rayfield Library
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/Fro-Fro69/buhimEppy/refs/heads/main/rayfield_frover.Lua'))()

local Window = Rayfield:CreateWindow({
    Name = "Rxz Is a Mf | Fro was here |",
    LoadingTitle = "Fro Hub",
    LoadingSubtitle = "by Fro-Fro",
    ConfigurationSaving = {
        Enabled = false
    },
})

local ATab = Window:CreateTab("Change Class Colors")
local ASection = ATab:CreateSection("Change Class Colors")

local BTab = Window:CreateTab("Change Relic Colors")
local BSection = ATab:CreateSection("Change Relic Colors")

local function getcurrentclass()
	return Player.Character:FindFirstChild("WeaponEquipped") or Player.Character:FindFirstChild("WeaponUnequip")
end

local function getcurrentrelic()
	return Player.Character:FindFirstChild("SubClass_Current")
end
-- Group parts by their initial color
local function groupPartsByColor(model)
	local groups = {}
	for _, part in ipairs(model:GetDescendants()) do
		if part:IsA("BasePart") then
			-- Only apply UsePartColor if NOT a MeshPart
			if part:IsA("UnionOperation") then
				part.UsePartColor = true
			end
			
			local colorKey = tostring(part.Color)
			if not groups[colorKey] then
				groups[colorKey] = {}
			end
			table.insert(groups[colorKey], part)
		end
	end
	return groups
end

local function setupColorPickers()
	local classModel = getcurrentclass()
	if not classModel then
		warn("No class model found!")
		return
	end

	local groupedParts = groupPartsByColor(classModel)
	for colorKey, partsList in pairs(groupedParts) do
		local firstPartColor = partsList[1].Color
		ATab:CreateColorPicker({
			Name = "Change color: "..tostring(firstPartColor),
			Color = firstPartColor,
			Callback = function(newColor)
				for _, part in ipairs(partsList) do
					part.Color = newColor
				end
			end
		})
	end
end

local function setupColorPickers2()
	local RelicModel = getcurrentrelic()
	if not RelicModel then
		warn("No class model found!")
		return
	end

	local groupedParts = groupPartsByColor(RelicModel)
	for colorKey, partsList in pairs(groupedParts) do
		local firstPartColor = partsList[1].Color
		BTab:CreateColorPicker({
			Name = "Change color: "..tostring(firstPartColor),
			Color = firstPartColor,
			Callback = function(newColor)
				for _, part in ipairs(partsList) do
					part.Color = newColor
				end
			end
		})
	end
end

local function rebuildTab()
	ATab:cleartab()
	setupColorPickers()
	ATab:CreateButton({
		Name = "Refresh Color Pickers",
		Callback = rebuildTab
	})
end

local function rebuildTab2()
	BTab:cleartab()
	setupColorPickers()
	BTab:CreateButton({
		Name = "Refresh Color Pickers",
		Callback = rebuildTab2
	})
end

-- Initial setup
setupColorPickers()
setupColorPickers2()
ATab:CreateButton({
	Name = "Refresh Color Pickers",
	Callback = rebuildTab
})
BTab:CreateButton({
	Name = "Refresh Color Pickers",
	Callback = rebuildTab2
})
