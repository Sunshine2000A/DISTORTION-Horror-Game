-- DISTORTION Act 1 Controller
-- Handles the Key Hunt sequence in the Dimension of Darkness

local GameConfig = require(script.Parent:WaitForChild("GameConfig"))
local MonsterAI = require(script.Parent:WaitForChild("MonsterAI"))
local AudioManager = require(script.Parent:WaitForChild("AudioManager"))
local RunService = game:GetService("RunService")

local Act1Controller = {}
Act1Controller.KeysCollected = 0
Act1Controller.Monster = nil
Act1Controller.Player = nil
Act1Controller.IsActive = false

-- Start Act 1
function Act1Controller:Start(player)
	self.Player = player
	self.KeysCollected = 0
	self.IsActive = true
	
	print("[Act1Controller] Starting Key Hunt...")
	
	-- Play horror drone
	AudioManager:PlayHorrorDrone()
	
	-- Create and spawn monster
	local monsterPos = Vector3.new(50, 5, 250)
	self.Monster = MonsterAI:CreateMonster(monsterPos, false)
	
	-- Listen for key collection
	local keyConnections = {}
	for _, key in pairs(workspace:FindFirstChild("DarkRoom"):GetChildren()) do
		if key.Name:match("HiddenKey") then
			local conn = key.Touched:Connect(function(hit)
				if hit.Parent == player.Character then
					self:CollectKey(key)
				end
			end)
			table.insert(keyConnections, conn)
		end
	end
	
	-- Update monster behavior
	local updateConn = RunService.RenderStepped:Connect(function()
		if self.IsActive and self.Monster then
			MonsterAI:UpdateBehavior(self.Monster, {})
		end
	end)
	
	print("[Act1Controller] Monster spawned. Collect 3 keys!")
end

-- Collect a key
function Act1Controller:CollectKey(key)
	self.KeysCollected = self.KeysCollected + 1
	print("[Act1Controller] Key " .. self.KeysCollected .. " collected!")
	
	key:Destroy()
	
	-- Check if all keys collected
	if self.KeysCollected >= GameConfig.Act1.KeysRequired then
		self:AllKeysCollected()
	end
end

-- All keys collected - transition to Act 2
function Act1Controller:AllKeysCollected()
	self.IsActive = false
	
	print("[Act1Controller] All keys collected! Vault door opening...")
	
	-- Spawn vault door with red light
	local vaultDoor = Instance.new("Part")
	vaultDoor.Name = "VaultDoor"
	vaultDoor.Size = Vector3.new(20, 30, 2)
	vaultDoor.CanCollide = true
	vaultDoor.Material = Enum.Material.Metal
	vaultDoor.BrickColor = BrickColor.new("Dark stone grey")
	vaultDoor.CFrame = CFrame.new(0, 15, 300)
	vaultDoor.Parent = workspace
	
	-- Red light
	local redLight = Instance.new("Part")
	redLight.Name = "RedLight"
	redLight.Shape = Enum.PartType.Ball
	redLight.Size = Vector3.new(1, 1, 1)
	redLight.CanCollide = false
	redLight.Material = Enum.Material.Neon
	redLight.BrickColor = BrickColor.new("Bright red")
	
	local redPointLight = Instance.new("PointLight")
	redPointLight.Brightness = 2
	redPointLight.Range = 100
	redPointLight.Color = Color3.fromRGB(255, 0, 0)
	redPointLight.Parent = redLight
	
	redLight.CFrame = vaultDoor.CFrame + Vector3.new(0, 0, -5)
	redLight.Parent = workspace
	
	print("[Act1Controller] Vault door visible. Act 2 ready.")
end

return Act1Controller
