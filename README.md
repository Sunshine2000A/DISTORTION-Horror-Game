# DISTORTION - Horror Game (Roblox)

A psychological horror game built in Roblox featuring multiple acts with escalating tension, AI-driven monsters, jump scares, and environmental horror.

## Game Structure

### 🚪 Prologue: The Normal Hallway
- Safe walk through a brightly lit hallway
- Sudden light flicker triggers transition to horror

### 🗝️ Act 1: Dimension of Darkness
- Collect 3 hidden keys in a pitch-black room
- Avoid "The Pursuer" monster with AI pathfinding
- Use flashlight strategically to avoid detection

### ⏳ Act 2: The Locked Vault
- Unlock a blast door under pressure
- Monsters spawn every 5 seconds
- Kite and manage multiple threats simultaneously

### 👁️ Act 3: Hallway of Madness
- Progressive psychological horror
- Zone A: Jump scares (painting, window hand)
- Zone B: Hallucinations (footsteps, flash jumpscare)
- Zone C: Final twist ending (void, endless fall)

## Installation

1. Open Roblox Studio
2. Create a new baseplate game
3. Import the scripts from `/src` directory into ServerScriptService
4. Configure game settings in `GameConfig.lua`
5. Test in Studio or publish to Roblox

## File Structure

```
DISTORTION-Horror-Game/
├── src/
│   ├── GameManager.lua          # Main game controller
│   ├── PrologueController.lua    # Prologue logic
│   ├── Act1Controller.lua        # Act 1 key hunt
│   ├── Act2Controller.lua        # Vault unlock sequence
│   ├── Act3Controller.lua        # Hallway of madness
│   ├── MonsterAI.lua             # Monster behavior
│   ├── FlashlightSystem.lua      # Flashlight mechanics
│   ├── AudioManager.lua          # Sound effects & music
│   └── GameConfig.lua            # Configuration settings
├── assets/
│   ├── models/
│   ├── sounds/
│   └── images/
└── README.md
```

## Features

- ✅ Multi-act horror progression
- ✅ AI monster with state-based behavior
- ✅ Dynamic jump scares
- ✅ Flashlight detection mechanics
- ✅ Audio-driven horror atmosphere
- ✅ Multiple hiding spots
- ✅ Procedural monster spawning
- ✅ Screen effects & glitches

## Development Notes

- Built for Roblox platform
- Uses Luau scripting language
- Requires Roblox Studio 2023+
- Target players: 8+ (with parental guidance)

## Setup Instructions for Roblox Studio

### Step 1: Create a New Game
1. Open **Roblox Studio**
2. Click **File** → **New** → Select **Baseplate** template
3. Save the game with name: "DISTORTION"

### Step 2: Add Scripts
1. In **Explorer** panel (left side), find **ServerScriptService**
2. Right-click → **Insert Object** → **ModuleScript**
3. Name it `GameConfig` and paste the code from `src/GameConfig.lua`
4. Repeat for: `GameManager`, `MonsterAI`, `FlashlightSystem`, `AudioManager`, `Act1Controller`, `Act2Controller`, `Act3Controller`
5. Create a new **LocalScript** in **StarterPlayer > StarterCharacterScripts** and add your main game initialization code

### Step 3: Configure Audio
1. Replace placeholder audio IDs in `AudioManager.lua` with real Roblox audio IDs:
   - Search Roblox audio library for: "horror", "scream", "glitch", etc.
   - Or create your own sound effects

### Step 4: Test the Game
1. Click **Play** in Studio to test
2. Adjust difficulty and jump scare timing in `GameConfig.lua` as needed

### Step 5: Publish
1. Once satisfied, click **File** → **Publish to Roblox**
2. Fill in game details and publish

---

**Created:** June 2026  
**Status:** In Development
