-- DISTORTION Audio Manager
-- Handles all sound effects, music, and ambient audio

local GameConfig = require(script.Parent:WaitForChild("GameConfig"))
local SoundService = game:GetService("SoundService")

local AudioManager = {}
AudioManager.Sounds = {}
AudioManager.MusicPlayer = nil

-- Audio Asset IDs (placeholder - replace with actual Roblox audio IDs)
AudioManager.Assets = {
	LightFlicker = "rbxassetid://0", -- Electrical spark sound
	HorrorDrone = "rbxassetid://0", -- Low frequency drone
	MonsterScream = "rbxassetid://0", -- Monster screech
	PaintingFall = "rbxassetid://0", -- Loud bang
	WindowSlam = "rbxassetid://0", -- Hand on glass
	Footsteps = "rbxassetid://0", -- Running footsteps
	FlashJumpscare = "rbxassetid://0", -- Ear-piercing shriek
	VoidMusic = "rbxassetid://0", -- Final music
	TriumphMusic = "rbxassetid://0", -- Relief music
	Glitch = "rbxassetid://0", -- Digital glitch
	Whisper = "rbxassetid://0" -- Chilling whisper
}

-- Create a sound player
function AudioManager:CreateSound(id, volume, parent, looped)
	local sound = Instance.new("Sound")
	sound.SoundId = id
	sound.Volume = volume or GameConfig.Audio.SFXVolume
	sound.Looped = looped or false
	sound.Parent = parent or workspace
	
	return sound
end

-- Play light flicker sound
function AudioManager:PlayLightFlicker()
	local sound = self:CreateSound(self.Assets.LightFlicker, GameConfig.Audio.SFXVolume, workspace)
	sound:Play()
	game:GetService("Debris"):AddItem(sound, 1)
end

-- Play horror drone (ambient)
function AudioManager:PlayHorrorDrone()
	local sound = self:CreateSound(self.Assets.HorrorDrone, GameConfig.Audio.AmbientVolume, workspace, true)
	sound:Play()
	return sound
end

-- Play monster scream
function AudioManager:PlayMonsterScream()
	local sound = self:CreateSound(self.Assets.MonsterScream, GameConfig.Audio.ShriekeVolume, workspace)
	sound:Play()
	game:GetService("Debris"):AddItem(sound, 3)
end

-- Play painting fall scare (Act 3)
function AudioManager:PlayPaintingFall()
	local sound = self:CreateSound(self.Assets.PaintingFall, GameConfig.Audio.SFXVolume, workspace)
	sound:Play()
	game:GetService("Debris"):AddItem(sound, 2)
end

-- Play window slam scare (Act 3)
function AudioManager:PlayWindowSlam()
	local sound = self:CreateSound(self.Assets.WindowSlam, GameConfig.Audio.SFXVolume, workspace)
	sound:Play()
	game:GetService("Debris"):AddItem(sound, 2)
end

-- Play footsteps scare (Act 3)
function AudioManager:PlayFootsteps()
	local sound = self:CreateSound(self.Assets.Footsteps, GameConfig.Audio.SFXVolume, workspace)
	sound:Play()
	game:GetService("Debris"):AddItem(sound, 3)
end

-- Play flash jumpscare shriek (Act 3)
function AudioManager:PlayFlashJumpscare()
	local sound = self:CreateSound(self.Assets.FlashJumpscare, GameConfig.Audio.ShriekeVolume, workspace)
	sound:Play()
	game:GetService("Debris"):AddItem(sound, 1)
end

-- Play final void music
function AudioManager:PlayVoidMusic()
	if self.MusicPlayer then
		self.MusicPlayer:Destroy()
	end
	
	self.MusicPlayer = self:CreateSound(self.Assets.VoidMusic, GameConfig.Audio.MusicVolume, workspace, true)
	self.MusicPlayer:Play()
end

-- Play triumph music
function AudioManager:PlayTriumphMusic()
	if self.MusicPlayer then
		self.MusicPlayer:Destroy()
	end
	
	self.MusicPlayer = self:CreateSound(self.Assets.TriumphMusic, GameConfig.Audio.MusicVolume, workspace, true)
	self.MusicPlayer:Play()
end

-- Play glitch sound
function AudioManager:PlayGlitch()
	local sound = self:CreateSound(self.Assets.Glitch, GameConfig.Audio.SFXVolume, workspace)
	sound:Play()
	game:GetService("Debris"):AddItem(sound, 1)
end

-- Play final whisper
function AudioManager:PlayWhisper(text)
	local sound = self:CreateSound(self.Assets.Whisper, GameConfig.Audio.AmbientVolume, workspace)
	sound:Play()
	game:GetService("Debris"):AddItem(sound, 5)
	print("[AudioManager] Whisper: " .. text)
end

-- Stop all music
function AudioManager:StopMusic()
	if self.MusicPlayer then
		self.MusicPlayer:Stop()
	end
end

return AudioManager
