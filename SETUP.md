# DISTORTION - Roblox Setup Guide

## Quick Start

### 1. **Create a New Roblox Game**
   - Open **Roblox Studio**
   - Click **File** → **New** → **Baseplate**
   - Save it as **"DISTORTION"**

### 2. **Add the Script Modules**

   In the **Explorer** panel (left side):

   a) **Create Module Scripts in ServerScriptService:**
      - Right-click **ServerScriptService** → **Insert Object** → **ModuleScript**
      - Name them: `GameConfig`, `GameManager`, `MonsterAI`, `FlashlightSystem`, `AudioManager`, `Act1Controller`, `Act2Controller`, `Act3Controller`
      - Copy the code from `/src` folder into each module

   b) **Create a Server Script to Initialize the Game:**
      - Right-click **ServerScriptService** → **Insert Object** → **Script**
      - Name it: `GameStart`
      - Add this code:

```lua
local GameManager = require(script.Parent:WaitForChild("GameManager"))

game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        GameManager:Init()
    end)
end)
```

### 3. **Add Audio (Optional but Recommended)**

   To use sound effects, replace the placeholder IDs in `AudioManager.lua`:

   ```lua
   AudioManager.Assets = {
       LightFlicker = "rbxassetid://123456789", -- Replace with real ID
       HorrorDrone = "rbxassetid://123456789",
       -- ... etc
   }
   ```

   You can find Roblox audio IDs by:
   - Going to Roblox Catalog
   - Finding sound effects
   - Copying the audio ID from the URL

### 4. **Test the Game**

   - Click **Play** in Studio
   - You should see:
     1. **Prologue**: Bright hallway → lights flicker
     2. **Act 1**: Dark room with keys to collect
     3. **Act 2**: Vault door unlock with monsters
     4. **Act 3**: Hallway with jump scares → final twist

### 5. **Customize**

   Adjust difficulty and timing in `GameConfig.lua`:
   - `Prologue.LightFlickerDelay` - When lights flicker
   - `Act1.FlashlightRange` - How far the flashlight reaches
   - `Monster.DetectionRange` - How far monsters can see
   - `Act2.MonsterSpawnInterval` - Time between monster spawns
   - `Act3.ZoneALength` - Size of scare zones

### 6. **Publish to Roblox** (When Ready)

   - Click **File** → **Publish to Roblox**
   - Fill in game details
   - Click **Create**
   - Share the link with friends!

---

## Troubleshooting

### Scripts not loading?
- Make sure all module scripts are in **ServerScriptService**
- Check the **Output** panel for error messages
- Verify file names match exactly

### No sounds playing?
- Add real Roblox audio IDs to `AudioManager.lua`
- Check that sound IDs are valid (start with `rbxassetid://`)

### Monsters not spawning?
- Ensure `MonsterAI.lua` is in the correct location
- Check the **Output** for error messages

### Game won't start?
- Restart Roblox Studio
- Check for syntax errors in scripts (red underlines)
- Delete and re-add the modules

---

## File Organization

```
ServerScriptService/
├── GameConfig (ModuleScript)
├── GameManager (ModuleScript)
├── MonsterAI (ModuleScript)
├── FlashlightSystem (ModuleScript)
├── AudioManager (ModuleScript)
├── Act1Controller (ModuleScript)
├── Act2Controller (ModuleScript)
├── Act3Controller (ModuleScript)
└── GameStart (Script) ← Initializes the game
```

---

## Next Steps

1. **Add custom models** instead of basic parts
2. **Add textures** to make it more visually horrifying
3. **Adjust monster AI** to be more intelligent
4. **Create custom jump scares** with decals and animations
5. **Balance difficulty** based on player feedback

Enjoy building horror! 🎮👹
