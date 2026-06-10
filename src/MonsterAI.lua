-- DISTORTION Monster AI System
-- Handles the behavior of "The Pursuer" and cloned monsters

local GameConfig = require(script.Parent:WaitForChild("GameConfig"))
local RunService = game:GetService("RunService")
local PathfindingService = game:GetService("PathfindingService")

local MonsterAI = {}
MonsterAI.Monsters = {}
MonsterAI.PlayerReference = nil

-- Create a monster instance
function MonsterAI:CreateMonster(position, isClone)
	local monster = Instance.new("Model")
	monster.Name = isClone and "PursuerClone" or "Pursuer"
	
	-- Body
	local body = Instance.new("Part")
	body.Name = "Body"
	body.Shape = Enum.PartType.Cylinder
	body.Size = Vector3.new(2, 8, 2)
	body.CanCollide = true
	body.Material = Enum.Material.SmoothPlastic
	body.BrickColor = BrickColor.new("Dark stone grey")
	body.TopSurface = Enum.SurfaceType.Smooth
	body.BottomSurface = Enum.SurfaceType.Smooth
	body.CFrame = CFrame.new(position + Vector3.new(0, 4, 0))
	body.Parent = monster
	
	-- Head
	local head = Instance.new("Part")
	head.Name = "Head"
	head.Shape = Enum.PartType.Ball
	head.Size = Vector3.new(1.5, 1.5, 1.5)
	head.CanCollide = false
	head.Material = Enum.Material.SmoothPlastic
	head.BrickColor = BrickColor.new("Dark stone grey")
	head.CFrame = body.CFrame + Vector3.new(0, 5, 0)
	head.Parent = monster
	
	local headWeld = Instance.new("WeldConstraint")
	headWeld.Part0 = body
	headWeld.Part1 = head
	headWeld.Parent = head
	
	-- Long arms
	local leftArm = Instance.new("Part")
	leftArm.Name = "LeftArm"
	leftArm.Shape = Enum.PartType.Cylinder
	leftArm.Size = Vector3.new(0.8, 6, 0.8)
	leftArm.CanCollide = false
	leftArm.Material = Enum.Material.SmoothPlastic
	leftArm.BrickColor = BrickColor.new("Dark stone grey")
	leftArm.CFrame = body.CFrame + Vector3.new(-3, 0, 0)
	leftArm.Parent = monster
	
	local leftArmWeld = Instance.new("WeldConstraint")
	leftArmWeld.Part0 = body
	leftArmWeld.Part1 = leftArm
	leftArmWeld.Parent = leftArm
	
	local rightArm = Instance.new("Part")
	rightArm.Name = "RightArm"
	rightArm.Shape = Enum.PartType.Cylinder
	rightArm.Size = Vector3.new(0.8, 6, 0.8)
	rightArm.CanCollide = false
	rightArm.Material = Enum.Material.SmoothPlastic
	rightArm.BrickColor = BrickColor.new("Dark stone grey")
	rightArm.CFrame = body.CFrame + Vector3.new(3, 0, 0)
	rightArm.Parent = monster
	
	local rightArmWeld = Instance.new("WeldConstraint")
	rightArmWeld.Part0 = body
	rightArmWeld.Part1 = rightArm
	rightArmWeld.Parent = rightArm
	
	-- Humanoid
	local humanoid = Instance.new("Humanoid")
	humanoid.Parent = monster
	
	-- State tracking
	local state = {
		Status = "Patrolling",
		TargetPlayer = nil,
		PatrolIndex = 1,
		Detected = false
	}
	
	-- Store reference
	table.insert(self.Monsters, {Model = monster, State = state, Humanoid = humanoid})
	
	monster.Parent = workspace
	print("[MonsterAI] Monster spawned at " .. tostring(position))
	
	return monster, state
end

-- Update monster behavior
function MonsterAI:UpdateBehavior(monster, state)
	local body = monster:FindFirstChild("Body")
	if not body then return end
	
	local playerCharacter = self.PlayerReference
	if not playerCharacter then return end
	
	local playerPos = playerCharacter:FindFirstChild("HumanoidRootPart").Position
	local monsterPos = body.Position
	local distance = (playerPos - monsterPos).Magnitude
	
	-- Check if player is within detection range
	if distance < GameConfig.Monster.DetectionRange then
		-- Look for flashlight beam or noise
		if self:IsPlayerDetected(playerPos, monsterPos) then
			state.Status = "Chasing"
			state.TargetPlayer = playerCharacter
			state.Detected = true
			
			-- Move toward player
			local direction = (playerPos - monsterPos).Unit
			body.AssemblyLinearVelocity = direction * GameConfig.Monster.ChaseSpeed
		else
			state.Status = "Patrolling"
			state.Detected = false
		end
	else
		state.Status = "Patrolling"
		state.Detected = false
	end
end

-- Check if player is detected
function MonsterAI:IsPlayerDetected(playerPos, monsterPos)
	-- Simple line-of-sight check
	local rayOrigin = monsterPos
	local rayDirection = (playerPos - monsterPos)
	
	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Whitelist
	raycastParams.FilterDescendantsInstances = {workspace}
	
	local rayResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
	
	return rayResult == nil or rayResult.Distance > (playerPos - monsterPos).Magnitude * 0.9
end

-- Play monster scream
function MonsterAI:PlayMonsterScream()
	print("[MonsterAI] MONSTER SCREAM!")
end

return MonsterAI
