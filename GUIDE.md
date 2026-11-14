# Haven Knight - Guide

## Run it
Godot 4.7.2 -> Import -> pick `project.godot` -> F5.
WASD move, mouse aim, left click attack.

## What the game is
- 2 heroes. **Gunner** (+25% gun damage). **Knight** (+50% melee damage, +30% reach).
- 3 dungeons x 7 floors. Floors 1-6 have enemies. Floor 7 is a boss.
- 1 chest per dungeon on a random floor (2-6). It gives a random new weapon.
- Beat a boss -> you get 1 random powerup (10 exist, no repeats) -> next dungeon.
- Each dungeon is harder: more enemy health, faster shooting, harder-hitting bosses.
- 9 weapons. Each hero can only use its own kind, and the chest only gives weapons your hero can use:
  - **Gunner (guns):** pistol, shotgun, smg, **bow** (high damage, slow), **sniper** (insane damage, very slow).
  - **Knight (melee):** sword, axe, **hammer** (spins around you, hits everything near), **katana** (very fast, low damage).

## New: weapon drops, obstacles, animation
- **Weapon drop:** open the chest and your old weapon is dropped next to it. Stand near any dropped weapon and press **E** to swap. The weapon you were holding stays on the ground, so you can always swap back. Drops stay on that floor only (leave through the door and they are gone).
- **Obstacles:** every floor except the boss floor gets 5-9 random barrels, cabinets and gravestones in new places each time. Bullets stop on them and nobody walks through them. They never cover the start spot, door or chest.
- **Animation:** the heroes, every enemy and every boss now play idle, run, attack, hurt and death animations. Enemy fireballs and magic balls are animated too.
  - How it works (`make_animated()` in `game.gd`): each animation is ONE picture with all frames side by side. The code cuts it into frames and plays them. To use a new character, add one entry to `ANIMS`.
  - In `player.gd` and `enemy.gd`: `play("run")` for looping animations, `play_once("attack")` for one-time ones. A `busy` flag stops "run" from interrupting an attack.
- Hero looks: Gunner = Huntress (shoots with a bow animation), Knight = Hero Knight. The weapon you hold is shown next to the health bar.

## Bounce back (when you die)
When your health hits 0 the game pauses and asks "do you want to BOUNCE BACK?". A black bar has one red square, and an arrow slides along the bar. Click when the arrow is over the red square and you come back with half health and 2 seconds of safety. Click anywhere else and the run is over. Every time you bounce back, the red square is half the size it was before (60, 30, 15, 7...), and it resets on a new run. It is in `scripts/bounce_back.gd`. To tune it: `SPEED` (arrow speed) and `RED_WIDTH` (size of the red square the first time) at the top of that file.

## Browse the textures and characters
- `scenes/texture_gallery.tscn` (open it, press F6): 5 pages of every texture in the packs. Keys 1-5 change page (walls and floors, weapons, creatures, Kenney tiles, big sheets), mouse wheel or arrows scroll, + and - zoom.
- `scenes/characters/gallery.tscn` (F6): the 11 game characters, keys 1-5 switch their animation.

## Code from the YouTube tutorials
**Public code, adapted into the game:**
| Part | Where it is in the game | Source |
|---|---|---|
| Boss state machine (`State`, `FiniteStateMachine`, Idle, Follow, Attack, Teleport, SpawnMinion, Death) | `scripts/boss.gd` and `scripts/boss/*.gd` | 16BitDev, [Boss Fight with Finite State Machine](https://www.youtube.com/watch?v=zh5bwenMn9o) (12 pastebin files from the video description) |
| Enemies walk around obstacles with `NavigationAgent2D` | `path_direction()` in `scripts/enemy.gd`, `build_navigation()` in `scripts/floor.gd` | ThinkWithGames, [Chase Players!](https://www.youtube.com/watch?v=Ykz7W9BHzPg), repo `Goldenlion5648/SmartEnemyMovementDemo`, MIT license |
| Only react when the player (not anything else) enters an area | `body.is_in_group("player")` in `idle.gd`, `enemy.gd`, `chest.gd`, `door.gd` | the same idea as the StackOverflow answer in the [body_entered video](https://www.youtube.com/watch?v=d9p-cqg0AjU). I could not open that page (bot check), so I did not copy it |

The 16BitDev pastebins have no license. I adapted the structure to our game and kept the credit. Bosses now show the name of their current state above their head. Set `SHOW_STATE = false` in `boss.gd` to hide it.

**Written in the style of the videos (their code is Patreon only, or not linked):**
- `scripts/slash.gd`: a melee hitbox (Area2D) made on every swing, hits each enemy once. From the Mostly Mad Productions sword slash and MrWonderHow hitbox videos.
- `scripts/enemy.gd`: a sight circle (enemies wait until you get close), a health bar node above the head, knockback with a tween, death animation then delete. From the Coding With Russ enemy AI video.
- `scripts/player.gd`: a `Timer` for the attack cooldown and a `Marker2D` muzzle for bullets. From the Mostly Mad Productions shooting video.
- `Game.change_to()` in `game.gd`: fade to black between scenes. From the scene transition videos.
- Pixel-sharp textures for the whole project (`default_texture_filter` in `project.godot`). From the texture filter video.

Not done: the TileMapLayer floor and the AnimationPlayer melee from the other videos.

The scripts have no explaining comments on purpose. This guide and the chat are where things get explained. The only comments left are one-line credits for the code adapted from 16BitDev and ThinkWithGames (their MIT license asks for that).

## Files (read them in this order, each is short)
| File | Job |
|---|---|
| `scripts/game.gd` | Brain. Heroes, weapons, powerups, art list, floor/dungeon counters, difficulty. |
| `scripts/menu.gd` | Hero select screen. |
| `scripts/floor.gd` | Builds one room: tile floor, walls, player, enemies or boss, chest, door. |
| `scripts/player.gd` | Move, aim, shoot guns, swing melee, take damage. |
| `scripts/bullet.gd` | One bullet for everyone (`hits = "enemies"` or `"player"`). |
| `scripts/enemy.gd` | Two kinds: `charger` and `shooter`. |
| `scripts/boss.gd` | Extends enemy.gd. 3 bosses, one per dungeon. |
| `scripts/chest.gd` | Walk into it, get a weapon, old weapon drops. |
| `scripts/weapon_drop.gd` | Weapon on the ground. Press E to swap. |
| `scripts/door.gd` | Appears when the floor is clear. Walk in = next floor. |
| `scripts/hud.gd` | Health bar, floor text, powerup icons, "you got a powerup" popup. |

Scenes in `scenes/` are one node each with a script on it. Everything else is built in code, so there is nothing hidden in the editor.

## How to explain it (the 6 ideas)
1. **Game.gd is the memory.** Any script reads `Game.hp`, `Game.dungeon`, etc.
2. **One floor scene, reloaded.** `Game.go_next_floor()` adds 1 to the floor number and reloads `floor.tscn`. The floor reads the number and decides what to spawn.
3. **Groups find things.** `player`, `enemies`, `walls`. Bullets ask "is the thing I touched in my `hits` group?"
4. **Charger = 3 states.** `walk` -> `windup` (stops, weapon glows yellow) -> `dash` (fast) -> repeat. See `do_charger()` in `enemy.gd`.
5. **Shooter = distance rule.** Too far: come closer. Too close: back away. Every 1.6s fire a bullet. See `do_shooter()`.
6. **Boss = enemy with its own `think()`.** `boss.gd` swaps in 3 attack styles: charger (reuses `do_charger`), ring of bullets, summon minions.

## Bosses
| Dungeon | Boss | Attack |
|---|---|---|
| 1 | Mad King | Dashes at you like the chargers, but huge |
| 2 | Evil Wizard | Circles you, fires a ring of 10 magic bullets |
| 3 | Fire Worm | Walks at you, fires 3 fireballs, summons 2 chargers |

## Easy things to change (to show others)
- Health, damage: `enemy_health()`, `boss_health()`, `hard()` in `game.gd`.
- New weapon: add one line to `WEAPONS` in `game.gd`.
- New powerup: add one line to `POWERUPS`, then one line in `apply_powerup()`.
- Different picture: change the number in the ART LIST at the top of `game.gd`. Tiny Dungeon pictures are numbered 0-131 (`assets/tiny-dungeon/Tiles/tile_0000.png`...).
- Enemies per floor: `spawn_enemies(2 + Game.floor_number)` in `floor.gd`.

## Art credits (all free; 12 packs are from itch.io)
| Used for | Pack | Folder | License | Link |
|---|---|---|---|---|
| Floors, walls, banners, crates, columns, chest, ladder, skulls | 16x16 DungeonTileset II (0x72) | `assets/itch/dungeontileset-ii` | CC0 | https://0x72.itch.io/dungeontileset-ii |
| Melee and bow icons (sword, katana, axe, hammer, bow) | Macrune's Weaponry (Macrune12) | `assets/itch/macrunes-weaponry` | free, credit optional | https://macrune12.itch.io/macrunes-weaponry |
| Gun icons (pistol, shotgun, smg, sniper) | Drawn by hand for this project (16x16, made with a small script) | `assets/icons` | mine | - |
| Knight hero | Hero Knight 2 (LuizMelo) | `assets/anim/hero-knight-2` | CC0 | https://luizmelo.itch.io/hero-knight-2 |
| Gunner hero + arrow | Huntress 2 (LuizMelo) | `assets/anim/huntress-2` | CC0 | https://luizmelo.itch.io/huntress-2 |
| Goblin, skeleton, flying eye | Monsters Creatures Fantasy (LuizMelo) | `assets/anim/monsters-creatures-fantasy` | CC0 | https://luizmelo.itch.io/monsters-creatures-fantasy |
| Mimic | Monsters Creatures Fantasy 2 (LuizMelo) | `assets/anim/monsters-creatures-fantasy-2` | CC0 | https://luizmelo.itch.io/monsters-creatures-fantasy-2 |
| Wizard shooter | Wizard Pack (LuizMelo) | `assets/anim/wizard-pack` | CC0 | https://luizmelo.itch.io/wizard-pack |
| Dark mage shooter + magic ball | Evil Wizard 3 (LuizMelo) | `assets/anim/evil-wizard-3` | CC0 | https://luizmelo.itch.io/evil-wizard-3 |
| Boss 1: Mad King | Medieval King Pack 2 (LuizMelo) | `assets/anim/medieval-king-pack-2` | CC0 | https://luizmelo.itch.io/medieval-king-pack-2 |
| Boss 2: Evil Wizard | Evil Wizard 2 (LuizMelo) | `assets/anim/evil-wizard-2` | CC0 | https://luizmelo.itch.io/evil-wizard-2 |
| Boss 3: Fire Worm + fireball | Fire Worm (LuizMelo) | `assets/anim/fire-worm` | CC0 | https://luizmelo.itch.io/fire-worm |
| Powerup potion icons | Tiny Dungeon (Kenney) | `assets/tiny-dungeon` | CC0 | https://kenney-assets.itch.io/tiny-dungeon |

The sword, axe, hammer, katana and bow icons were cut out of Macrune's Weaponry into `assets/icons/` (see `ICON` in `game.gd`). The Macrune pack folder is not in the GitHub repo because its license does not clearly allow re-sharing the pack. Download it from the link above if you want the full pack.

## Sound (4 free Kenney packs in `assets/audio/`, CC0, from kenney.nl, not itch.io)
Links: https://kenney.nl/assets/digital-audio, https://kenney.nl/assets/rpg-audio, https://kenney.nl/assets/impact-sounds, https://kenney.nl/assets/music-jingles
- **Digital Audio**: gun shots, enemy shots, powerup chime.
- **RPG Audio**: sword slash, axe chop, chest coins, door, menu click, charger windup.
- **Impact Sounds**: enemy hit, enemy death, player hurt, boss bell.
- **Music Jingles**: short jingles for dungeon start, win and death.
- There is no looping background music. Kenney's free packs only have short jingles.
- All sounds are listed in `SOUNDS` in `game.gd`. Play one anywhere with `Game.play_sound("hit")`. Change a sound by changing its file name in that list.

## Tested
A bot played both heroes through all 3 dungeons (21 floors each): both enemy kinds spawn, each boss spawns, obstacles appear on every non-boss floor and never on boss floors, the chest drops the old weapon and pressing E swaps it back, door and powerup popup work, win screen shows. Screenshots of every boss floor were checked. Not tested by a human with a mouse yet.
