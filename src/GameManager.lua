-- DISTORTION Horror Game Manager
-- Main controller for game flow and state management

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local GameConfig = require(script.Parent:WaitForChild("GameConfig"))

local GameManager = {}
GameManager.CurrentAct = GameConfig.ACTS.Prologue
GameManager.IsGameActive = false
GameManager.Player = nil
GameManager.Character = nil
GameManager.Humanoid = nil

-- Initialize the game
function GameManager:Init()
	self.Player = Players.LocalPlayer
	self.Character = self.Player.Character or self.Player.CharacterAdded:Wait()
	self.Humanoid = self.Character:WaitForChild("Humanoid")
	self.IsGameActive = true
	
	print("[GameManager] Initializing DISTORTION...")
	self:StartPrologue()
end

-- Prologue: Safe hallway walk
function GameManager:StartPrologue()
	self.CurrentAct = GameConfig.ACTS.Prologue
	print("[GameManager] Starting Prologue...")
	
	-- Create hallway
	local hallway = Instance.new("Part")
	hallway.Name = "PrologueHallway"
	hallway.Size = Vector3.new(20, 15, GameConfig.Prologue.HallwayLength)
	hallway.CanCollide = true
	hallway.Material = Enum.Material.Tile
	hallway.TopSurface = Enum.SurfaceType.Smooth
	hallway.BottomSurface = Enum.SurfaceType.Smooth
	hallway.BrickColor = BrickColor.new("Institutional white")
	hallway.CFrame = CFrame.new(0, 0, 0)
	hallway.Parent = workspace
	
	-- Add ambient lighting
	local light = Instance.new("Part")
	light.Name = "PrologueLight"
	light.Shape = Enum.PartType.Ball
	light.CanCollide = false
	light.Size = Vector3.new(2, 2, 2)
	light.TopSurface = Enum.SurfaceType.Smooth
	light.BottomSurface = Enum.SurfaceType.Smooth
	light.BrickColor = BrickColor.new("Bright yellow")
	light.CanCollide = false
	local pointLight = Instance.new("PointLight")
	pointLight.Brightness = 2
	pointLight.Range = 60
	pointLight.Parent = light
	
	light.CFrame = CFrame.new(0, 8, GameConfig.Prologue.HallwayLength / 2)
	light.Parent = workspace
	
	-- Move player to start position
	self.Character:MoveTo(Vector3.new(0, 5, -30))
	
	-- Wait for player to walk
	wait(GameConfig.Prologue.LightFlickerDelay)
	
	-- Trigger light flicker
	self:TriggerLightFlicker(light)
end

-- Light flicker effect
function GameManager:TriggerLightFlicker(light)
	local pointLight = light:FindFirstChildOfClass("PointLight")
	if pointLight then
		local originalBrightness = pointLight.Brightness
		pointLight.Brightness = 0
		wait(GameConfig.Prologue.LightFlickerDuration)
		pointLight.Brightness = originalBrightness
	end
	
	-- Transition to Act 1
	wait(0.5)
	self:StartAct1()
end

-- Act 1: Key hunt in darkness
function GameManager:StartAct1()
	self.CurrentAct = GameConfig.ACTS.Act1
	print("[GameManager] Starting Act 1: Dimension of Darkness...")
	
	-- Remove prologue
	for _, part in pairs(workspace:GetChildren()) do
		if part.Name:match("Prologue") then
			part:Destroy()
		end
	end
	
	-- Create Act 1 environment (dark room)
	local darkRoom = Instance.new("Part")
	darkRoom.Name = "DarkRoom"
	darkRoom.Size = Vector3.new(GameConfig.Act1.RoomSize.X, GameConfig.Act1.RoomSize.Y, GameConfig.Act1.RoomSize.Z)
	darkRoom.CanCollide = true
	darkRoom.Material = Enum.Material.Concrete
	darkRoom.BrickColor = BrickColor.new("Dark stone grey")
	darkRoom.TopSurface = Enum.SurfaceType.Smooth
	darkRoom.BottomSurface = Enum.SurfaceType.Smooth
	darkRoom.CFrame = CFrame.new(0, 0, 200)
	darkRoom.Parent = workspace
	
	-- Add global darkness
	local lighting = game:GetService("Lighting")
	lighting.Ambient = Color3.fromRGB(0, 0, 0)
	lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
	
	-- Equip flashlight to player
	self:EquipFlashlight()
	
	-- Spawn hidden keys
	self:SpawnKeys()
	
	-- Spawn monster
	self:SpawnMonster()
	
	print("[GameManager] Act 1 environment ready. Find 3 keys!")
end

-- Equip flashlight to player
function GameManager:EquipFlashlight()
	local flashlight = Instance.new("Part")
	flashlight.Name = "Flashlight"
	flashlight.Shape = Enum.PartType.Cylinder
	flashlight.Size = Vector3.new(0.5, 2, 0.5)
	flashlight.CanCollide = false
	flashlight.Material = Enum.Material.Metal
	flashlight.BrickColor = BrickColor.new("Dark stone grey")
	
	local pointLight = Instance.new("PointLight")
	pointLight.Brightness = GameConfig.Act1.FlashlightMaxBrightness
	pointLight.Range = GameConfig.Act1.FlashlightRange
	pointLight.Color = Color3.fromRGB(255, 255, 200)
	pointLight.Parent = flashlight
	
	-- Weld to player's right hand
	local rightHand = self.Character:WaitForChild("RightHand")
	local weld = Instance.new("WeldConstraint")
	weld.Part0 = rightHand
	weld.Part1 = flashlight
	weld.Parent = flashlight
	
	flashlight.Parent = self.Character
	print("[GameManager] Flashlight equipped.")
end

-- Spawn 3 hidden keys
function GameManager:SpawnKeys()
	local keyPositions = {
		Vector3.new(-60, 5, 250),
		Vector3.new(60, 5, 150),
		Vector3.new(0, 5, 350)
	}
	
	for i, pos in ipairs(keyPositions) do
		local key = Instance.new("Part")
		key.Name = "HiddenKey" .. i
		key.Shape = Enum.PartType.Cylinder
		key.Size = Vector3.new(1, 1, 1)
		key.CanCollide = true
		key.Material = Enum.Material.Neon
		key.BrickColor = BrickColor.new("Bright yellow")
		key.CanCollide = false
		key.CFrame = CFrame.new(pos)
		key.Parent = workspace
		
		-- Add glow
		local light = Instance.new("PointLight")
		light.Brightness = 1
		light.Range = 20
		light.Color = Color3.fromRGB(255, 255, 0)
		light.Parent = key
	end
	
	print("[GameManager] Spawned 3 keys.")
end

-- Spawn the main monster
function GameManager:SpawnMonster()
	print("[GameManager] Monster spawned in shadows.")
end

-- Act 2: Vault unlock
function GameManager:StartAct2()
	self.CurrentAct = GameConfig.ACTS.Act2
	print("[GameManager] Starting Act 2: The Locked Vault...")
end

-- Act 3: Hallway of madness
function GameManager:StartAct3()
	self.CurrentAct = GameConfig.ACTS.Act3
	print("[GameManager] Starting Act 3: Hallway of Madness...")
end

-- Game over sequence
function GameManager:GameOver(reason)
	self.IsGameActive = false
	print("[GameManager] GAME OVER - " .. reason)
end

-- Initialize on script load
if RunService:IsClient() then
	GameManager:Init()
end

return GameManager
