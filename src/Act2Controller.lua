-- DISTORTION Act 2 Controller
-- Handles the Vault Unlock sequence with monster spawning

local GameConfig = require(script.Parent:WaitForChild("GameConfig"))
local MonsterAI = require(script.Parent:WaitForChild("MonsterAI"))
local AudioManager = require(script.Parent:WaitForChild("AudioManager"))
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Act2Controller = {}
Act2Controller.UnlockProgress = 0
Act2Controller.IsUnlocking = false
Act2Controller.MonstersSpawned = 0
Act2Controller.SpawnedMonsters = {}
Act2Controller.IsActive = false

-- Start Act 2
function Act2Controller:Start(player, vaultDoor)
	self.Player = player
	self.VaultDoor = vaultDoor
	self.IsActive = true
	self.UnlockProgress = 0
	self.MonstersSpawned = 0
	
	print("[Act2Controller] Starting Vault Unlock sequence...")
	
	-- Create proximity prompt on vault door
	local prompt = Instance.new("ProximityPrompt")
	prompt.ActionText = "Unlock"
	prompt.ObjectText = "Vault Door"
	prompt.MaxActivationDistance = 25
	prompt.Parent = vaultDoor
	
	-- Handle unlock interaction
	local function onPromptTriggered()
		self:StartUnlocking(player)
	end
	
	prompt.Triggered:Connect(onPromptTriggered)
	
	print("[Act2Controller] Approach the vault door to unlock it.")
end

-- Start the unlock sequence
function Act2Controller:StartUnlocking(player)
	if self.IsUnlocking then return end
	self.IsUnlocking = true
	
	print("[Act2Controller] Unlock sequence initiated!")
	
	-- Spawn first monster
	AudioManager:PlayMonsterScream()
	local firstMonster = MonsterAI:CreateMonster(Vector3.new(0, 5, 250), true)
	table.insert(self.SpawnedMonsters, firstMonster)
	self.MonstersSpawned = 1
	
	-- Spawn new monsters every 5 seconds
	local spawnTimer = 0
	local updateConn = RunService.RenderStepped:Connect(function(deltaTime)
		if not self.IsActive then
			updateConn:Disconnect()
			return
		end
		
		spawnTimer = spawnTimer + deltaTime
		
		-- Spawn new monster every 5 seconds
		if spawnTimer >= GameConfig.Act2.MonsterSpawnInterval and self.MonstersSpawned < GameConfig.Act2.MaxMonstersSpawned then
			local randomPos = Vector3.new(math.random(-50, 50), 5, math.random(200, 280))
			local newMonster = MonsterAI:CreateMonster(randomPos, true)
			table.insert(self.SpawnedMonsters, newMonster)
			self.MonstersSpawned = self.MonstersSpawned + 1
			AudioManager:PlayMonsterScream()
			spawnTimer = 0
		end
		
		-- Update unlock progress while holding button
		if self.IsUnlocking then
			self.UnlockProgress = self.UnlockProgress + (deltaTime / GameConfig.Act2.UnlockDuration)
			
			if self.UnlockProgress >= 1 then
				self:CompleteUnlock()
				updateConn:Disconnect()
			end
		end
	end)
end

-- Complete the unlock
function Act2Controller:CompleteUnlock()
	self.IsUnlocking = false
	self.IsActive = false
	
	print("[Act2Controller] Vault door unlocked!")
	
	-- Open door
	local vaultDoor = self.VaultDoor
	if vaultDoor then
		local tweenService = game:GetService("TweenService")
		local tweenInfo = TweenInfo.new(
			GameConfig.Act2.VaultDoorOpenDuration,
			Enum.EasingStyle.Linear,
			Enum.EasingDirection.InOut
		)
		local tweenGoals = {CFrame = vaultDoor.CFrame + Vector3.new(0, 0, -25)}
		
		local tween = tweenService:Create(vaultDoor, tweenInfo, tweenGoals)
		tween:Play()
		
		wait(GameConfig.Act2.VaultDoorOpenDuration)
		
		-- Remove monsters
		for _, monster in pairs(self.SpawnedMonsters) do
			if monster and monster.Parent then
				monster:Destroy()
			end
		end
		
		-- Silence
		wait(1)
		print("[Act2Controller] Act 2 complete. Proceeding to Act 3...")
	end
end

return Act2Controller
