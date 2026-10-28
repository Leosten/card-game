# 🀄 Tactical Roguelike Deckbuilder

> A roguelike deckbuilder inspired by *Slay the Spire*, where every fight plays out on a **tactical grid** instead of a simple face-off. Positioning, area-of-effect zones, and reading enemy intentions matter just as much as the cards in your deck.

![Godot](https://img.shields.io/badge/Godot-4.7-478CBF?logo=godotengine&logoColor=white)
![GDScript](https://img.shields.io/badge/GDScript-100%25-blue)
![Status](https://img.shields.io/badge/status-in%20development-yellow)

## 🎮 Concept

Instead of attacking the enemy across from you, every card targets **specific cells on an 8x4 grid** split into player and enemy territory. Area-of-effect spells (beams, blasts, cones...) hit multiple targets depending on where they land — strategy is as much about *positioning* as it is about *deckbuilding*.

## ✨ Features

- **Grid-based combat**: player/enemy territories, area-of-effect patterns with a live preview before you commit to playing a card
- **Enemy intent telegraphing**: monster actions are highlighted on the grid in advance, so you can react before they strike
- **35+ cards** across 4 types (Attack, Magic, Elemental, Buff) and 3 rarities (Common / Purple / Gold)
- **Status effect system**: Vulnerable, Stun, Fire Affinity, Frozen Bite, Regen, Foresight...
- **Forge**: upgrade your cards with rarity-based pricing tiers
- **Companion**: an allied unit with its own progression, fighting alongside the player
- **Procedural map generation**: a branching 13-floor path layout with a crossing-prevention algorithm (inspired by Slay the Spire's map system)
- **Shop** and card upgrade system (Reinforce, Rally, Copy, Purify)
- **Japanese Themed bestiary**: goblin, tiger, lucky cat, yokai... animated with modular sprites

## 🛠️ Tech stack & architecture

- **Engine**: Godot 4.7 (GDScript), GL Compatibility renderer
- **Manager-driven architecture**: logic split into autoload singletons (`GameManager`, `Events`, `SceneLoader`) plus dedicated managers (`GridManager`, `BattleState`, `StatusManager`, `MapManager`, `ForgeManager`...) to keep state, combat, UI, and scene loading cleanly separated
- **Data-driven cards**: every card is a Godot `Resource` (`.tres`) loaded dynamically via recursive folder scanning — adding a new card requires no code changes
- **Generic targeting engine**: a single affected-cells calculator (`TargetingUtils`) shared between player cards and monster actions

## 📸 Screenshots

<img width="961" height="542" alt="Screenshot 2026-10-28 180634" src="https://github.com/user-attachments/assets/9dfdb040-c337-4c97-ae44-fed76522a569" />
<img width="959" height="542" alt="Screenshot 2026-10-28 174225" src="https://github.com/user-attachments/assets/455c09b8-0b19-43b7-ad34-fa194949096e" />
<img width="962" height="542" alt="Screenshot 2026-10-28 174812" src="https://github.com/user-attachments/assets/3004f9cc-bf22-435f-a433-c05566dd14a3" />
<img width="964" height="541" alt="Screenshot 2026-10-28 180748" src="https://github.com/user-attachments/assets/f0707a26-de6d-4646-8a94-4dcaf451e705" />



## 🚧 Roadmap

- [ ] Bestiary and card balancing
- [ ] Relics / passive items
- [ ] UI/UX polish and visual effects
- [ ] Sounds
- [ ] Exportable build (Windows/Web)

## ▶️ Running the project

```bash
git clone https://github.com/Leosten/card-game.git
# Open the folder with Godot 4.7+
```
