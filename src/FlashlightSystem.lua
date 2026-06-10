-- DISTORTION Flashlight System
-- Manages flashlight mechanics, detection, and effects

local GameConfig = require(script.Parent:WaitForChild("GameConfig"))
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local FlashlightSystem = {}
FlashlightSystem.Flashlight = nil
FlashlightSystem.IsActive = true
FlashlightSystem.Brightness = GameConfig.Act1.FlashlightMaxBrightness
FlashlightSystem.FlickerTimer = 0

-- Initialize flashlight
function FlashlightSystem:Init(flashlightPart)
	self.Flashlight = flashlightPart
	self.IsActive = true
	
	-- Listen for mouse input to move flashlight
	if RunService:IsClient() then
		RunService.RenderStepped:Connect(function()
			self:UpdateFlashlightDirection()
			self:UpdateFlashlightFlicker()
		end)
	end
	
	print("[FlashlightSystem] Flashlight initialized.")
end

-- Update flashlight direction based on camera
function FlashlightSystem:UpdateFlashlightDirection()
	if not self.Flashlight or not self.Flashlight.Parent then return end
	
	local camera = workspace.CurrentCamera
	local flashlightLight = self.Flashlight:FindFirstChildOfClass("PointLight")
	
	if flashlightLight then
		-- Point light in camera direction
		self.Flashlight.CFrame = camera.CFrame + camera.CFrame.LookVector * 5
	end
end

-- Handle flashlight flickering
function FlashlightSystem:UpdateFlashlightFlicker()
	if not self.Flashlight or not self.IsActive then return end
	
	local light = self.Flashlight:FindFirstChildOfClass("PointLight")
	if not light then return end
	
	self.FlickerTimer = self.FlickerTimer + 1
	
	-- Random flicker chance
	if math.random() < GameConfig.Act1.FlashlightFlickerChance and self.FlickerTimer > 30 then
		light.Brightness = GameConfig.Act1.FlashlightMinBrightness
		wait(0.2)
		light.Brightness = self.Brightness
		self.FlickerTimer = 0
	end
end

-- Reduce flashlight intensity (Act 3 Zone A)
function FlashlightSystem:ReduceIntensity(factor)
	if not self.Flashlight then return end
	
	local light = self.Flashlight:FindFirstChildOfClass("PointLight")
	if light then
		light.Brightness = light.Brightness * factor
		self.Brightness = light.Brightness
	end
end

-- Break flashlight (Act 3 Zone C)
function FlashlightSystem:BreakFlashlight()
	if not self.Flashlight then return end
	
	local light = self.Flashlight:FindFirstChildOfClass("PointLight")
	if light then
		light.Brightness = 0
	end
	
	self.IsActive = false
	
	-- Fade out and remove
	local tweenService = game:GetService("TweenService")
	local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.In)
	local tweenGoals = {Transparency = 1}
	
	local tween = tweenService:Create(self.Flashlight, tweenInfo, tweenGoals)
	tween:Play()
	
	wait(1)
	self.Flashlight:Destroy()
	print("[FlashlightSystem] Flashlight broken.")
end

-- Check if flashlight is shining on a point (for monster detection)
function FlashlightSystem:IsShiningOn(targetPosition)
	if not self.Flashlight or not self.IsActive then return false end
	
	local light = self.Flashlight:FindFirstChildOfClass("PointLight")
	if not light then return false end
	
	local distance = (self.Flashlight.Position - targetPosition).Magnitude
	return distance < light.Range
end

return FlashlightSystem
