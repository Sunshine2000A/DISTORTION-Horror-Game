-- DISTORTION Horror Game Configuration
-- Central configuration file for all game mechanics

local GameConfig = {}

-- Game Progression
GameConfig.ACTS = {
	Prologue = 1,
	Act1 = 2,
	Act2 = 3,
	Act3 = 4,
	GameOver = 5
}

-- Prologue Settings
GameConfig.Prologue = {
	HallwayLength = 100,
	WalkSpeed = 16,
	LightFlickerDelay = 5,
	LightFlickerDuration = 0.5
}

-- Act 1: Key Hunt Settings
GameConfig.Act1 = {
	RoomSize = {X = 200, Y = 50, Z = 200},
	KeysRequired = 3,
	FlashlightRange = 80,
	FlashlightMaxBrightness = 3,
	FlashlightMinBrightness = 1,
	FlashlightFlickerChance = 0.3
}

-- Monster AI Settings
GameConfig.Monster = {
	WalkSpeed = 25,
	ChaseSpeed = 45,
	DetectionRange = 150,
	DetectionAngle = 120,
	HearingRange = 200,
	ScareDistance = 30,
	PatrolWaypoints = 6,
	PathfindingGridSize = 10
}

-- Act 2: Vault Unlock Settings
GameConfig.Act2 = {
	UnlockDuration = 25,
	MonsterSpawnInterval = 5,
	MaxMonstersSpawned = 6,
	VaultDoorOpenDuration = 2,
	KiteArea = {X = 150, Y = 40, Z = 150}
}

-- Act 3: Hallway of Madness Settings
GameConfig.Act3 = {
	ZoneALength = 50,
	ZoneBLength = 50,
	ZoneCLength = 30,
	TotalHallwayLength = 130,
	FlashlightIntensityZoneA = 0.7,
	FlashlightIntensityZoneB = 0.4,
	FlashlightIntensityZoneC = 0, -- Flashlight breaks
	BlackoutDuration = 2.5,
	FlashJumpscareDuration = 0.3,
	VoidMusic = "rbxassetid://VOID_MUSIC_ID",
	TriumphMusic = "rbxassetid://TRIUMPH_MUSIC_ID"
}

-- Audio Settings
GameConfig.Audio = {
	MasterVolume = 1,
	SFXVolume = 0.8,
	MusicVolume = 0.6,
	AmbientVolume = 0.5,
	HorrorDroneVolume = 0.7,
	ShriekeVolume = 0.9
}

-- Gameplay Settings
GameConfig.Gameplay = {
	DifficultyMode = "Normal", -- Easy, Normal, Hard
	AllowPauseInAct1 = false,
	AllowPauseInAct2 = false,
	AllowPauseInAct3 = false,
	EnableDeathCamera = true,
	DeathCameraFallDuration = 5
}

-- UI Settings
GameConfig.UI = {
	ButtonSize = UDim2.new(0, 150, 0, 50),
	ButtonColor = Color3.fromRGB(200, 0, 0),
	TextColor = Color3.fromRGB(255, 255, 255),
	HUDOpacity = 0.8
}

return GameConfig
