-- DISTORTION Act 3 Controller
-- Handles the Hallway of Madness with jump scares and final twist

local GameConfig = require(script.Parent:WaitForChild("GameConfig"))
local AudioManager = require(script.Parent:WaitForChild("AudioManager"))
local FlashlightSystem = require(script.Parent:WaitForChild("FlashlightSystem"))
local RunService = game:GetService("RunService")

local Act3Controller = {}
Act3Controller.CurrentZone = "A"
Act3Controller.IsActive = false
Act3Controller.Player = nil
Act3Controller.HallwayStart = Vector3.new(0, 5, 350)

-- Start Act 3
function Act3Controller:Start(player)
	self.Player = player
	self.IsActive = true
	self.CurrentZone = "A"
	
	print("[Act3Controller] Starting Act 3: Hallway of Madness...")
	
	-- Create hallway
	local hallway = Instance.new("Part")
	hallway.Name = "MadnessHallway"
	hallway.Size = Vector3.new(15, 12, GameConfig.Act3.TotalHallwayLength)
	hallway.CanCollide = true
	hallway.Material = Enum.Material.Wood
	hallway.BrickColor = BrickColor.new("Dark stone grey")
	hallway.CFrame = CFrame.new(0, 0, 400)
	hallway.Parent = workspace
	
	-- Move player to hallway start
	player.Character:MoveTo(self.HallwayStart)
	
	-- Track player progress
	local trackingConn = RunService.RenderStepped:Connect(function()
		if self.IsActive and player.Character then
			local playerPos = player.Character:FindFirstChild("HumanoidRootPart").Position
			local distanceTraveled = (playerPos.Z - self.HallwayStart.Z)
			
			-- Zone A: High Tension (0-50m)
			if distanceTraveled < GameConfig.Act3.ZoneALength then
				if self.CurrentZone ~= "A" then
					self:EnterZoneA()
					self.CurrentZone = "A"
				end
				
			-- Zone B: Hallucinations (50-100m)
			elseif distanceTraveled < GameConfig.Act3.ZoneALength + GameConfig.Act3.ZoneBLength then
				if self.CurrentZone ~= "B" then
					self:EnterZoneB()
					self.CurrentZone = "B"
				end
				
			-- Zone C: The Void (100m+)
			else
				if self.CurrentZone ~= "C" then
					self:EnterZoneC()
					self.CurrentZone = "C"
					trackingConn:Disconnect()
				end
		end
	end)
end

-- Enter Zone A: High Tension
function Act3Controller:EnterZoneA()
	print("[Act3Controller] Entering Zone A: High Tension...")
	
	-- Reduce flashlight brightness
	FlashlightSystem:ReduceIntensity(0.7)
	
	-- Scare 1: Painting falls
	wait(2)
	self:PlayPaintingFall()
	
	-- Scare 2: Hand on window
	wait(3)
	self:PlayWindowSlam()
end

-- Enter Zone B: Hallucinations
function Act3Controller:EnterZoneB()
	print("[Act3Controller] Entering Zone B: Hallucinations...")
	
	-- Reduce flashlight more
	FlashlightSystem:ReduceIntensity(0.6)
	
	-- Scare 3: Footsteps
	wait(2)
	self:PlayFootstepsScare()
	
	-- Scare 4: Flash jumpscare
	wait(3)
	self:PlayFlashJumpscare()
end

-- Enter Zone C: The Void (Final Twist)
function Act3Controller:EnterZoneC()
	print("[Act3Controller] Entering Zone C: The Void...")
	
	-- Break flashlight
	FlashlightSystem:BreakFlashlight()
	
	-- Play triumph music
	AudioManager:PlayTriumphMusic()
	
	-- Create exit door
	local exitDoor = Instance.new("Part")
	exitDoor.Name = "ExitDoor"
	exitDoor.Size = Vector3.new(8, 10, 0.5)
	exitDoor.CanCollide = false
	exitDoor.Material = Enum.Material.Neon
	exitDoor.BrickColor = BrickColor.new("Bright yellow")
	exitDoor.CanCollide = false
	exitDoor.CFrame = CFrame.new(0, 5, 500)
	exitDoor.Parent = workspace
	
	-- Add light to exit
	local exitLight = Instance.new("PointLight")
	exitLight.Brightness = 3
	exitLight.Range = 50
	exitLight.Color = Color3.fromRGB(255, 255, 255)
	exitLight.Parent = exitDoor
	
	-- Player approaches exit
	wait(2)
	
	-- Player is one step away from exit
	-- TWIST: Floor vanishes
	AudioManager:PlayGlitch()
	AudioManager:StopMusic()
	
	print("[Act3Controller] THE TWIST!")
	
	-- Screen effect: Void
	self:PlayEndingSequence()
end

-- Play painting fall scare
function Act3Controller:PlayPaintingFall()
	print("[Act3Controller] Painting falls!")
	AudioManager:PlayPaintingFall()
end

-- Play window slam scare
function Act3Controller:PlayWindowSlam()
	print("[Act3Controller] Hand slams window!")
	AudioManager:PlayWindowSlam()
end

-- Play footsteps scare
function Act3Controller:PlayFootstepsScare()
	print("[Act3Controller] Footsteps approach!")
	AudioManager:PlayFootsteps()
end

-- Play flash jumpscare
function Act3Controller:PlayFlashJumpscare()
	print("[Act3Controller] FLASH JUMPSCARE!")
	
	-- Blackout
	local camera = workspace.CurrentCamera
	camera.Parent = workspace
	
	-- Dim screen
	wait(1)
	AudioManager:PlayFlashJumpscare()
	
	print("[Act3Controller] Jumpscare played.")
end

-- Final ending sequence
function Act3Controller:PlayEndingSequence()
	print("[Act3Controller] GAME OVER - You will never wake up.")
	
	-- Play final whisper
	AudioManager:PlayWhisper("You will never wake up.")
	
	-- Fade to black
	wait(3)
	
	-- Redirect to credits or menu
	print("[Act3Controller] Redirecting to menu...")
end

return Act3Controller
