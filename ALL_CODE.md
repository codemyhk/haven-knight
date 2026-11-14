# Haven Knight - ALL THE CODE

21 scripts, all in the `scripts` folder of the project (the boss states are in `scripts/boss`). `game.gd` has to be an Autoload named `Game`.

---

## scripts/game.gd

```gdscript
extends Node

const FLOORS_PER_DUNGEON = 7
const TOTAL_DUNGEONS = 3
const FLOOR_SCENE = "res://scenes/floor.tscn"
const MENU_SCENE = "res://scenes/menu.tscn"

const TD = "res://assets/tiny-dungeon/Tiles/tile_"
const DT = "res://assets/itch/dungeontileset-ii/0x72_DungeonTilesetII_v1.7/frames/"

const DUNGEON_TINTS = [Color.WHITE, Color(0.8, 1.0, 0.8), Color(0.78, 0.68, 1.0)]

const AN = "res://assets/anim/"
const MCF = AN + "monsters-creatures-fantasy/Monsters_Creatures_Fantasy/"
const MCF2 = AN + "monsters-creatures-fantasy-2/Monsters Creatures Fantasy 2/"
const ANIMS = {
	"knight": {"frame": Vector2i(140, 140), "scale": 1.7, "offset": Vector2(0, 6), "height": 66, "radius": 12,
		"idle": AN + "hero-knight-2/Hero Knight 2/Sprites/Idle.png",
		"run": AN + "hero-knight-2/Hero Knight 2/Sprites/Run.png",
		"attack": AN + "hero-knight-2/Hero Knight 2/Sprites/Attack.png",
		"hurt": AN + "hero-knight-2/Hero Knight 2/Sprites/Take Hit.png",
		"death": AN + "hero-knight-2/Hero Knight 2/Sprites/Death.png"},
	"huntress": {"frame": Vector2i(100, 100), "scale": 1.9, "offset": Vector2(-1, 1), "height": 68, "radius": 12,
		"idle": AN + "huntress-2/Huntress 2/Sprites/Character/Idle.png",
		"run": AN + "huntress-2/Huntress 2/Sprites/Character/Run.png",
		"attack": AN + "huntress-2/Huntress 2/Sprites/Character/Attack.png",
		"hurt": AN + "huntress-2/Huntress 2/Sprites/Character/Get Hit.png",
		"death": AN + "huntress-2/Huntress 2/Sprites/Character/Death.png"},
	"goblin": {"frame": Vector2i(150, 150), "scale": 1.4, "offset": Vector2(0, -8), "height": 50, "radius": 14,
		"idle": MCF + "Goblin/Idle.png", "run": MCF + "Goblin/Run.png", "attack": MCF + "Goblin/Attack.png",
		"hurt": MCF + "Goblin/Take Hit.png", "death": MCF + "Goblin/Death.png"},
	"skeleton": {"frame": Vector2i(150, 150), "scale": 1.05, "offset": Vector2(-5, 0), "height": 54, "radius": 14,
		"idle": MCF + "Skeleton/Idle.png", "run": MCF + "Skeleton/Walk.png", "attack": MCF + "Skeleton/Attack.png",
		"hurt": MCF + "Skeleton/Take Hit.png", "death": MCF + "Skeleton/Death.png"},
	"mimic": {"frame": Vector2i(146, 146), "scale": 1.4, "offset": Vector2(-4, 5), "height": 42, "radius": 16,
		"idle": MCF2 + "Mimic/idle_transformed.png", "run": MCF2 + "Mimic/walk.png", "attack": MCF2 + "Mimic/attack_1.png",
		"hurt": MCF2 + "Mimic/hurt.png", "death": MCF2 + "Mimic/death.png"},
	"flyeye": {"frame": Vector2i(150, 150), "scale": 1.4, "offset": Vector2(-2, -1), "height": 44, "radius": 14,
		"idle": MCF + "Flying eye/Flight.png", "run": MCF + "Flying eye/Flight.png", "attack": MCF + "Flying eye/Attack.png",
		"hurt": MCF + "Flying eye/Take Hit.png", "death": MCF + "Flying eye/Death.png"},
	"wizard": {"frame": Vector2i(231, 190), "scale": 0.8, "offset": Vector2(5, -3), "height": 70, "radius": 14,
		"idle": AN + "wizard-pack/Wizard Pack/Idle.png", "run": AN + "wizard-pack/Wizard Pack/Run.png",
		"attack": AN + "wizard-pack/Wizard Pack/Attack1.png", "hurt": AN + "wizard-pack/Wizard Pack/Hit.png",
		"death": AN + "wizard-pack/Wizard Pack/Death.png"},
	"darkmage": {"frame": Vector2i(140, 140), "scale": 1.3, "offset": Vector2(-3, 0), "height": 68, "radius": 14,
		"idle": AN + "evil-wizard-3/Evil Wizard 3/Sprites/Idle.png", "run": AN + "evil-wizard-3/Evil Wizard 3/Sprites/Run.png",
		"attack": AN + "evil-wizard-3/Evil Wizard 3/Sprites/Attack.png", "hurt": AN + "evil-wizard-3/Evil Wizard 3/Sprites/Get hit.png",
		"death": AN + "evil-wizard-3/Evil Wizard 3/Sprites/Death.png"},
	"king": {"frame": Vector2i(160, 111), "scale": 2.2, "offset": Vector2(0, -22), "height": 120, "radius": 32,
		"idle": AN + "medieval-king-pack-2/Medieval King Pack 2/Sprites/Idle.png",
		"run": AN + "medieval-king-pack-2/Medieval King Pack 2/Sprites/Run.png",
		"attack": AN + "medieval-king-pack-2/Medieval King Pack 2/Sprites/Attack1.png",
		"hurt": AN + "medieval-king-pack-2/Medieval King Pack 2/Sprites/Take Hit.png",
		"death": AN + "medieval-king-pack-2/Medieval King Pack 2/Sprites/Death.png"},
	"evilwizard": {"frame": Vector2i(250, 250), "scale": 1.6, "offset": Vector2(-11, 5), "height": 105, "radius": 36,
		"idle": AN + "evil-wizard-2/EVil Wizard 2/Sprites/Idle.png", "run": AN + "evil-wizard-2/EVil Wizard 2/Sprites/Run.png",
		"attack": AN + "evil-wizard-2/EVil Wizard 2/Sprites/Attack1.png", "hurt": AN + "evil-wizard-2/EVil Wizard 2/Sprites/Take hit.png",
		"death": AN + "evil-wizard-2/EVil Wizard 2/Sprites/Death.png"},
	"fireworm": {"frame": Vector2i(90, 90), "scale": 2.6, "offset": Vector2(2, 7), "height": 105, "radius": 40,
		"idle": AN + "fire-worm/Fire Worm/Sprites/Worm/Idle.png", "run": AN + "fire-worm/Fire Worm/Sprites/Worm/Walk.png",
		"attack": AN + "fire-worm/Fire Worm/Sprites/Worm/Attack.png", "hurt": AN + "fire-worm/Fire Worm/Sprites/Worm/Get Hit.png",
		"death": AN + "fire-worm/Fire Worm/Sprites/Worm/Death.png"},
}

const PROJECTILES = {
	"fire":  {"path": AN + "fire-worm/Fire Worm/Sprites/Fire Ball/Move.png", "frame": 46, "scale": 0.8},
	"magic": {"path": AN + "evil-wizard-3/Evil Wizard 3/Sprites/Projectile/Moving.png", "frame": 50, "scale": 0.8},
}
const PROJECTILE_BY_DUNGEON = ["fire", "magic", "fire"]
const ARROW = AN + "huntress-2/Huntress 2/Sprites/Arrow/Static.png"

const CHARGERS = ["goblin", "skeleton", "mimic"]
const SHOOTERS = ["flyeye", "wizard", "darkmage"]
const BOSSES = [
	{"name": "Mad King",    "anim": "king"},
	{"name": "Evil Wizard", "anim": "evilwizard"},
	{"name": "Fire Worm",   "anim": "fireworm"},
]

const SND = "res://assets/audio/"
const SOUNDS = {
	"pistol":       SND + "digital-audio/Audio/laser2.ogg",
	"shotgun":      SND + "digital-audio/Audio/laser7.ogg",
	"smg":          SND + "digital-audio/Audio/laser4.ogg",
	"sword":        SND + "rpg-audio/Audio/knifeSlice.ogg",
	"axe":          SND + "rpg-audio/Audio/chop.ogg",
	"bow":          SND + "digital-audio/Audio/zap1.ogg",
	"sniper":       SND + "impact-sounds/Audio/impactMetal_heavy_000.ogg",
	"hammer":       SND + "impact-sounds/Audio/impactPlate_heavy_000.ogg",
	"katana":       SND + "rpg-audio/Audio/knifeSlice2.ogg",
	"enemy_shoot":  SND + "digital-audio/Audio/laser9.ogg",
	"hit":          SND + "impact-sounds/Audio/impactGeneric_light_000.ogg",
	"enemy_die":    SND + "impact-sounds/Audio/impactPunch_heavy_000.ogg",
	"player_hurt":  SND + "impact-sounds/Audio/impactPunch_medium_000.ogg",
	"windup":       SND + "rpg-audio/Audio/drawKnife1.ogg",
	"chest":        SND + "rpg-audio/Audio/handleCoins.ogg",
	"door":         SND + "rpg-audio/Audio/doorOpen_1.ogg",
	"powerup":      SND + "digital-audio/Audio/powerUp5.ogg",
	"boss":         SND + "impact-sounds/Audio/impactBell_heavy_000.ogg",
	"click":        SND + "rpg-audio/Audio/metalClick.ogg",
	"start":        SND + "music-jingles/Audio/Steel jingles/jingles_STEEL00.ogg",
	"win":          SND + "music-jingles/Audio/8-Bit jingles/jingles_NES00.ogg",
	"lose":         SND + "music-jingles/Audio/Hit jingles/jingles_HIT00.ogg",
}

const CHARACTERS = {
	"gunner": {"name": "Gunner", "buff": "+25% gun damage\nguns only", "start_weapon": "pistol", "weapon_type": "gun", "anim": "huntress"},
	"knight": {"name": "Knight", "buff": "+50% melee damage, +30% reach\nmelee only", "start_weapon": "sword", "weapon_type": "melee", "anim": "knight"},
}

const ICON = "res://assets/icons/"
const WEAPONS = {
	"pistol":  {"type": "gun", "damage": 10,  "cooldown": 0.35, "bullets": 1, "spread": 0.0,  "speed": 600.0,  "style": "ball",   "art": ICON + "pistol.png"},
	"shotgun": {"type": "gun", "damage": 6,   "cooldown": 0.8,  "bullets": 5, "spread": 0.3,  "speed": 550.0,  "style": "ball",   "art": ICON + "shotgun.png"},
	"smg":     {"type": "gun", "damage": 5,   "cooldown": 0.12, "bullets": 1, "spread": 0.15, "speed": 650.0,  "style": "ball",   "art": ICON + "smg.png"},
	"bow":     {"type": "gun", "damage": 45,  "cooldown": 1.1,  "bullets": 1, "spread": 0.0,  "speed": 850.0,  "style": "arrow",  "art": ICON + "bow.png"},
	"sniper":  {"type": "gun", "damage": 140, "cooldown": 2.4,  "bullets": 1, "spread": 0.0,  "speed": 1700.0, "style": "tracer", "art": ICON + "sniper.png"},
	"sword":   {"type": "melee", "damage": 20, "cooldown": 0.4,  "range": 70.0,  "art": ICON + "sword.png"},
	"axe":     {"type": "melee", "damage": 35, "cooldown": 0.8,  "range": 95.0,  "art": ICON + "axe.png"},
	"hammer":  {"type": "melee", "damage": 40, "cooldown": 1.0,  "range": 110.0, "spin": true, "art": ICON + "hammer.png"},
	"katana":  {"type": "melee", "damage": 7,  "cooldown": 0.15, "range": 80.0,  "art": ICON + "katana.png"},
}

const POWERUPS = {
	"damage":    {"name": "Sharp Edge",    "text": "+25% damage",                       "icon": TD + "0115.png"},
	"speed":     {"name": "Swift Boots",   "text": "+20% move speed",                   "icon": TD + "0114.png"},
	"rapid":     {"name": "Quick Hands",   "text": "attack 20% faster",                 "icon": TD + "0116.png"},
	"heart":     {"name": "Big Heart",     "text": "+30 max HP (and heal 30)",          "icon": TD + "0127.png"},
	"armor":     {"name": "Iron Skin",     "text": "take 20% less damage",              "icon": TD + "0102.png"},
	"vampire":   {"name": "Vampire Fang",  "text": "heal 3 HP per kill",                "icon": TD + "0125.png"},
	"crit":      {"name": "Lucky Clover",  "text": "+15% chance to deal double damage", "icon": TD + "0128.png"},
	"multishot": {"name": "Twin Barrel",   "text": "+1 bullet per gun shot",            "icon": TD + "0130.png"},
	"reach":     {"name": "Long Grip",     "text": "+30% melee reach",                  "icon": TD + "0131.png"},
	"pierce":    {"name": "Sharp Bullets", "text": "bullets go through +1 enemy",       "icon": TD + "0105.png"},
}

var character = "gunner"
var dungeon = 1
var floor_number = 1
var chest_floor = 3
var weapon_id = "pistol"
var owned_powerups = []
var max_hp = 100.0
var hp = 100.0
var stats = {}
var message = ""
var bounces = 0
var fade = ColorRect.new()
var changing = false


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	var fade_layer = CanvasLayer.new()
	fade_layer.layer = 100
	fade.color = Color(0, 0, 0, 0)
	fade.size = Vector2(1152, 648)
	fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fade_layer.add_child(fade)
	add_child(fade_layer)
	_add_key("move_up", KEY_W)
	_add_key("move_up", KEY_UP)
	_add_key("move_down", KEY_S)
	_add_key("move_down", KEY_DOWN)
	_add_key("move_left", KEY_A)
	_add_key("move_left", KEY_LEFT)
	_add_key("move_right", KEY_D)
	_add_key("move_right", KEY_RIGHT)
	_add_key("interact", KEY_E)
	InputMap.add_action("attack")
	var click = InputEventMouseButton.new()
	click.button_index = MOUSE_BUTTON_LEFT
	InputMap.action_add_event("attack", click)
	reset_stats()


func _add_key(action, key):
	if not InputMap.has_action(action):
		InputMap.add_action(action)
	var e = InputEventKey.new()
	e.physical_keycode = key
	InputMap.action_add_event(action, e)


func play_sound(sound_name, volume_db = 0.0):
	var player = AudioStreamPlayer.new()
	player.stream = load(SOUNDS[sound_name])
	player.volume_db = volume_db
	add_child(player)
	player.finished.connect(player.queue_free)
	player.play()


func reset_stats():
	stats = {
		"damage": 1.0, "speed": 1.0, "cooldown": 1.0, "armor": 0.0,
		"heal_on_kill": 0.0, "crit": 0.0, "extra_bullets": 0, "reach": 1.0, "pierce": 0,
	}


func make_sprite(path, size):
	var s = Sprite2D.new()
	s.texture = load(path)
	s.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	fit_sprite(s, size)
	return s


func fit_sprite(s, size):
	s.scale = Vector2.ONE * (float(size) / max(s.texture.get_width(), s.texture.get_height()))


func add_strip(frames, anim_name, path, frame_size, fps, loop):
	var strip = load(path)
	var count = int(strip.get_width() / float(frame_size.x))
	frames.add_animation(anim_name)
	frames.set_animation_loop(anim_name, loop)
	frames.set_animation_speed(anim_name, fps)
	for i in count:
		var piece = AtlasTexture.new()
		piece.atlas = strip
		piece.region = Rect2(i * frame_size.x, 0, frame_size.x, frame_size.y)
		frames.add_frame(anim_name, piece)


func make_animated(who):
	var info = ANIMS[who]
	var frames = SpriteFrames.new()
	frames.remove_animation("default")
	add_strip(frames, "idle", info["idle"], info["frame"], 8.0, true)
	add_strip(frames, "run", info["run"], info["frame"], 12.0, true)
	add_strip(frames, "attack", info["attack"], info["frame"], 14.0, false)
	add_strip(frames, "hurt", info["hurt"], info["frame"], 12.0, false)
	add_strip(frames, "death", info["death"], info["frame"], 10.0, false)
	var s = AnimatedSprite2D.new()
	s.sprite_frames = frames
	s.scale = Vector2.ONE * info["scale"]
	s.offset = info["offset"]
	s.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	s.play("idle")
	return s


func make_projectile(kind):
	var info = PROJECTILES[kind]
	var frames = SpriteFrames.new()
	frames.remove_animation("default")
	add_strip(frames, "move", info["path"], Vector2i(info["frame"], info["frame"]), 12.0, true)
	var s = AnimatedSprite2D.new()
	s.sprite_frames = frames
	s.scale = Vector2.ONE * info["scale"]
	s.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	s.play("move")
	return s


func tile_path(number):
	return TD + "%04d.png" % number


func start_run(hero):
	character = hero
	weapon_id = CHARACTERS[hero]["start_weapon"]
	dungeon = 1
	owned_powerups = []
	max_hp = 100.0
	hp = max_hp
	message = ""
	bounces = 0
	reset_stats()
	start_dungeon()


func start_dungeon():
	floor_number = 1
	chest_floor = randi_range(2, FLOORS_PER_DUNGEON - 1)


func go_to_floor_scene():
	change_to(FLOOR_SCENE)


func change_to(path):
	if changing:
		return
	changing = true
	var tween = create_tween()
	tween.tween_property(fade, "color:a", 1.0, 0.25)
	await tween.finished
	get_tree().change_scene_to_file(path)
	tween = create_tween()
	tween.tween_property(fade, "color:a", 0.0, 0.25)
	await tween.finished
	changing = false


func go_next_floor():
	floor_number += 1
	hp = min(hp + 20, max_hp)
	go_to_floor_scene()


func finish_dungeon(powerup_id):
	if powerup_id != "":
		apply_powerup(powerup_id)
	dungeon += 1
	if dungeon > TOTAL_DUNGEONS:
		message = "YOU WIN! All 3 dungeons cleared!"
		play_sound("win")
		change_to(MENU_SCENE)
	else:
		start_dungeon()
		go_to_floor_scene()


func game_over():
	message = "You died on dungeon %d, floor %d" % [dungeon, floor_number]
	get_tree().paused = false
	play_sound("lose")
	change_to(MENU_SCENE)


func pick_random_powerup():
	var left = []
	for id in POWERUPS:
		if not owned_powerups.has(id):
			left.append(id)
	if left.is_empty():
		return ""
	return left.pick_random()


func apply_powerup(id):
	owned_powerups.append(id)
	match id:
		"damage":    stats["damage"] *= 1.25
		"speed":     stats["speed"] *= 1.2
		"rapid":     stats["cooldown"] *= 0.8
		"heart":
			max_hp += 30
			hp = min(hp + 30, max_hp)
		"armor":     stats["armor"] += 0.2
		"vampire":   stats["heal_on_kill"] += 3
		"crit":      stats["crit"] += 0.15
		"multishot": stats["extra_bullets"] += 1
		"reach":     stats["reach"] *= 1.3
		"pierce":    stats["pierce"] += 1


func random_weapon():
	var allowed = []
	for id in WEAPONS:
		if WEAPONS[id]["type"] == CHARACTERS[character]["weapon_type"] and id != weapon_id:
			allowed.append(id)
	return allowed.pick_random()


func damage_for(weapon_type, base):
	var d = base * stats["damage"]
	if weapon_type == "gun" and character == "gunner":
		d *= 1.25
	if weapon_type == "melee" and character == "knight":
		d *= 1.5
	if randf() < stats["crit"]:
		d *= 2.0
	return d


func melee_reach(base):
	var r = base * stats["reach"]
	if character == "knight":
		r *= 1.3
	return r


func hard():
	return 1.0 + 0.3 * (dungeon - 1)


func enemy_health():
	return 30.0 * (1.0 + 0.4 * (dungeon - 1))


func boss_health():
	return 450.0 * (1.0 + 0.6 * (dungeon - 1))


func on_enemy_killed():
	hp = min(hp + stats["heal_on_kill"], max_hp)
```

---

## scripts/menu.gd

```gdscript
extends Control

func _ready():
	var background = ColorRect.new()
	background.color = Color(0.08, 0.08, 0.12)
	background.size = Vector2(1152, 648)
	add_child(background)

	var title = Label.new()
	title.text = "HAVEN KNIGHT - pick your hero"
	title.add_theme_font_size_override("font_size", 32)
	title.position = Vector2(300, 60)
	add_child(title)

	if Game.message != "":
		var msg = Label.new()
		msg.text = Game.message
		msg.add_theme_font_size_override("font_size", 22)
		msg.position = Vector2(380, 130)
		add_child(msg)

	var x = 260
	for id in Game.CHARACTERS:
		var info = Game.CHARACTERS[id]

		var picture = Game.make_animated(info["anim"])
		picture.scale *= 2.0
		picture.position = Vector2(x + 120, 270)
		add_child(picture)

		var button = Button.new()
		button.text = info["name"]
		button.position = Vector2(x + 20, 360)
		button.size = Vector2(200, 50)
		button.pressed.connect(_on_pick.bind(id))
		add_child(button)

		var buff = Label.new()
		buff.text = info["buff"]
		buff.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		buff.custom_minimum_size = Vector2(240, 0)
		buff.position = Vector2(x, 420)
		add_child(buff)

		x += 400

	var help = Label.new()
	help.text = "WASD move   Mouse aim   Left click attack   Beat 3 dungeons (7 floors each)"
	help.position = Vector2(300, 580)
	add_child(help)


func _on_pick(id):
	Game.play_sound("click")
	Game.start_run(id)
	Game.go_to_floor_scene()
```

---

## scripts/floor.gd

```gdscript
extends Node2D

const PLAYER = preload("res://scenes/player.tscn")
const ENEMY = preload("res://scenes/enemy.tscn")
const BOSS = preload("res://scenes/boss.tscn")
const CHEST = preload("res://scenes/chest.tscn")
const DOOR = preload("res://scenes/door.tscn")
const HUD = preload("res://scripts/hud.gd")

const TILE = 48
const ROOM = Rect2(96, 96, 960, 480)

const OBSTACLES = [
	{"picture": "crate",  "size": 72, "lift": -16, "box": Vector2(40, 40)},
	{"picture": "column", "size": 96, "lift": -28, "box": Vector2(30, 30)},
]

var hud = null
var cleared = false
var obstacle_spots = []
var obstacle_boxes = []


func _ready():
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	y_sort_enabled = true
	build_tiles()
	build_walls()

	var player = PLAYER.instantiate()
	add_child(player)
	player.global_position = ROOM.get_center() + Vector2(0, 150)

	hud = HUD.new()
	add_child(hud)

	if Game.floor_number == 1:
		Game.play_sound("start")
	if Game.floor_number == Game.FLOORS_PER_DUNGEON:
		Game.play_sound("boss")
		build_navigation()
		spawn_boss()
	else:
		spawn_obstacles()
		build_navigation()
		spawn_enemies(2 + Game.floor_number)

	if Game.floor_number == Game.chest_floor:
		var chest = CHEST.instantiate()
		add_child(chest)
		chest.global_position = ROOM.position + Vector2(100, 100)

	scatter_decor()


func _process(_delta):
	if cleared:
		return
	if get_tree().get_nodes_in_group("enemies").is_empty():
		cleared = true
		if Game.floor_number == Game.FLOORS_PER_DUNGEON:
			hud.show_powerup(Game.pick_random_powerup())
		else:
			Game.play_sound("door")
			var door = DOOR.instantiate()
			add_child(door)
			door.global_position = Vector2(ROOM.get_center().x, ROOM.position.y + 40)


func spawn_enemies(count):
	for i in count:
		var e = ENEMY.instantiate()
		if i % 2 == 0:
			e.kind = "charger"
		else:
			e.kind = "shooter"
		add_child(e)
		var spot = Vector2.ZERO
		for attempt in 20:
			spot = Vector2(
				randf_range(ROOM.position.x + 60, ROOM.end.x - 60),
				randf_range(ROOM.position.y + 60, ROOM.position.y + 200))
			if not touches_obstacle(spot, 50.0):
				break
		e.global_position = spot


func spawn_obstacles():
	var count = randi_range(5, 9)
	for i in count:
		for attempt in 30:
			var gx = randi_range(1, 18)
			var gy = randi_range(1, 8)
			var center = ROOM.position + (Vector2(gx, gy) + Vector2(0.5, 0.5)) * TILE
			if obstacle_spot_is_free(center):
				place_obstacle(center)
				break


func obstacle_spot_is_free(center):
	if center.distance_to(ROOM.get_center() + Vector2(0, 150)) < 120.0:
		return false
	if center.distance_to(Vector2(ROOM.get_center().x, ROOM.position.y + 40)) < 110.0:
		return false
	if center.distance_to(ROOM.position + Vector2(100, 100)) < 110.0:
		return false
	return not touches_obstacle(center, 110.0)


func touches_obstacle(spot, distance):
	for other in obstacle_spots:
		if spot.distance_to(other) < distance:
			return true
	return false


func place_obstacle(center):
	obstacle_spots.append(center)
	var kind = OBSTACLES.pick_random()
	obstacle_boxes.append(Rect2(center - kind["box"] / 2.0, kind["box"]))
	var body = StaticBody2D.new()
	body.add_to_group("walls")
	var shape = CollisionShape2D.new()
	var rect = RectangleShape2D.new()
	rect.size = kind["box"]
	shape.shape = rect
	body.add_child(shape)
	var picture = Game.make_sprite(Game.DT + kind["picture"] + ".png", kind["size"])
	picture.position.y = kind["lift"]
	body.add_child(picture)
	body.position = center
	add_child(body)


func build_navigation():
	var polygon = NavigationPolygon.new()
	polygon.agent_radius = 16.0
	var source = NavigationMeshSourceGeometryData2D.new()
	source.add_traversable_outline(corners(ROOM))
	for box in obstacle_boxes:
		source.add_obstruction_outline(corners(box))
	NavigationServer2D.bake_from_source_geometry_data(polygon, source)
	var region = NavigationRegion2D.new()
	region.navigation_polygon = polygon
	add_child(region)


func corners(rect):
	return PackedVector2Array([
		rect.position, Vector2(rect.end.x, rect.position.y),
		rect.end, Vector2(rect.position.x, rect.end.y)])


func spawn_boss():
	var b = BOSS.instantiate()
	add_child(b)
	b.global_position = Vector2(ROOM.get_center().x, ROOM.position.y + 110)


func build_walls():
	var t = 48.0
	wall(Rect2(ROOM.position.x - t, ROOM.position.y - t, ROOM.size.x + 2 * t, t))
	wall(Rect2(ROOM.position.x - t, ROOM.end.y, ROOM.size.x + 2 * t, t))
	wall(Rect2(ROOM.position.x - t, ROOM.position.y, t, ROOM.size.y))
	wall(Rect2(ROOM.end.x, ROOM.position.y, t, ROOM.size.y))


func wall(r):
	var body = StaticBody2D.new()
	body.add_to_group("walls")
	var shape = CollisionShape2D.new()
	var rect = RectangleShape2D.new()
	rect.size = r.size
	shape.shape = rect
	body.add_child(shape)
	body.position = r.get_center()
	add_child(body)


func build_tiles():
	var tint = Game.DUNGEON_TINTS[Game.dungeon - 1]
	var background = ColorRect.new()
	background.color = Color(0.04, 0.04, 0.06)
	background.size = Vector2(1152, 648)
	background.z_index = -10
	add_child(background)

	var banner_columns = [randi_range(2, 6), randi_range(8, 12), randi_range(14, 18)]

	for gx in range(-1, 21):
		for gy in range(-1, 11):
			var is_wall = gx == -1 or gx == 20 or gy == -1 or gy == 10
			var picture = ""
			if not is_wall:
				picture = "floor_%d" % randi_range(2, 8)
				if randf() < 0.65:
					picture = "floor_1"
			elif gx == -1:
				picture = "wall_left"
			elif gx == 20:
				picture = "wall_right"
			elif gy == -1 and banner_columns.has(gx):
				picture = ["wall_banner_red", "wall_banner_blue", "wall_banner_green"].pick_random()
			elif gy == -1 and randf() < 0.1:
				picture = ["wall_hole_1", "wall_goo"].pick_random()
			else:
				picture = "wall_mid"
			var tile = Game.make_sprite(Game.DT + picture + ".png", TILE)
			tile.position = ROOM.position + (Vector2(gx, gy) + Vector2(0.5, 0.5)) * TILE
			tile.z_index = -5
			tile.modulate = tint
			add_child(tile)

	shade(Rect2(ROOM.position, Vector2(ROOM.size.x, 26)), 0.45)
	shade(Rect2(ROOM.position, Vector2(14, ROOM.size.y)), 0.3)
	shade(Rect2(Vector2(ROOM.end.x - 14, ROOM.position.y), Vector2(14, ROOM.size.y)), 0.3)


func shade(area, darkness):
	var rect = ColorRect.new()
	rect.color = Color(0, 0, 0, darkness)
	rect.position = area.position
	rect.size = area.size
	rect.z_index = -4
	add_child(rect)


func scatter_decor():
	for i in 3:
		var skull = Game.make_sprite(Game.DT + "skull.png", 36)
		skull.position = Vector2(
			randf_range(ROOM.position.x + 40, ROOM.end.x - 40),
			randf_range(ROOM.position.y + 40, ROOM.end.y - 40))
		skull.z_index = -3
		add_child(skull)
```

---

## scripts/player.gd

```gdscript
extends CharacterBody2D

const BASE_SPEED = 220.0
const BULLET = preload("res://scenes/bullet.tscn")
const BOUNCE_BACK = preload("res://scripts/bounce_back.gd")
const SLASH = preload("res://scripts/slash.gd")

var aim_dir = Vector2.RIGHT
var fire_timer = Timer.new()
var muzzle = Marker2D.new()
var swing_time = 0.0
var spin_time = 0.0
var spin_angle = 0.0
var spin_sprite = null
var invulnerable = 0.0
var sprite = null
var busy = false
var dead = false


func _ready():
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	add_to_group("player")
	var shape = CollisionShape2D.new()
	var circle = CircleShape2D.new()
	circle.radius = 12
	shape.shape = circle
	add_child(shape)

	sprite = Game.make_animated(Game.CHARACTERS[Game.character]["anim"])
	sprite.animation_finished.connect(_on_animation_finished)
	add_child(sprite)

	spin_sprite = Sprite2D.new()
	spin_sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	spin_sprite.visible = false
	add_child(spin_sprite)

	fire_timer.one_shot = true
	add_child(fire_timer)
	add_child(muzzle)


func _physics_process(delta):
	if dead:
		return

	var dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = dir * BASE_SPEED * Game.stats["speed"]
	move_and_slide()

	aim_dir = (get_global_mouse_position() - global_position).normalized()

	swing_time -= delta
	spin_time -= delta
	invulnerable -= delta
	if Input.is_action_pressed("attack") and fire_timer.is_stopped():
		attack()

	sprite.flip_h = aim_dir.x < 0.0
	if invulnerable > 0.0:
		sprite.modulate = Color(1, 0.5, 0.5)
	else:
		sprite.modulate = Color.WHITE
	if velocity.length() > 10.0:
		play("run")
	else:
		play("idle")

	spin_sprite.visible = spin_time > 0.0
	if spin_time > 0.0:
		spin_angle += 14.0 * delta
		spin_sprite.position = Vector2.from_angle(spin_angle) * 55.0
		spin_sprite.rotation = spin_angle + PI / 4.0
	queue_redraw()


func play(anim_name):
	if not busy and sprite.animation != anim_name:
		sprite.play(anim_name)


func play_once(anim_name):
	busy = true
	sprite.play(anim_name)


func _on_animation_finished():
	if not dead:
		busy = false


func attack():
	var w = Game.WEAPONS[Game.weapon_id]
	fire_timer.start(w["cooldown"] * Game.stats["cooldown"])
	if Game.weapon_id == "smg":
		Game.play_sound(Game.weapon_id, -8.0)
	else:
		Game.play_sound(Game.weapon_id, -2.0)
	play_once("attack")
	if w["type"] == "gun":
		shoot(w)
	else:
		melee(w)


func shoot(w):
	muzzle.position = aim_dir * 30
	var count = w["bullets"] + Game.stats["extra_bullets"]
	for i in count:
		var fan = (i - (count - 1) / 2.0) * 0.12
		var wobble = randf_range(-w["spread"], w["spread"])
		var b = BULLET.instantiate()
		b.direction = aim_dir.rotated(fan + wobble)
		b.speed = w["speed"]
		b.damage = Game.damage_for("gun", w["damage"])
		b.pierce = Game.stats["pierce"]
		b.style = w["style"]
		get_tree().current_scene.add_child(b)
		b.global_position = muzzle.global_position


func melee(w):
	var reach = Game.melee_reach(w["range"])
	var spinning = w.get("spin", false)
	if spinning:
		spin_time = 0.45
		spin_sprite.texture = load(w["art"])
		Game.fit_sprite(spin_sprite, 64)
	else:
		swing_time = 0.12
	var slash = SLASH.new()
	slash.damage = Game.damage_for("melee", w["damage"])
	slash.reach = reach
	slash.spin = spinning
	if spinning:
		slash.position = Vector2.ZERO
	else:
		slash.position = aim_dir * reach * 0.6
	add_child(slash)


func take_damage(amount, _push = Vector2.ZERO):
	if invulnerable > 0.0 or dead:
		return
	invulnerable = 0.5
	Game.play_sound("player_hurt")
	Game.hp -= amount * (1.0 - Game.stats["armor"])
	if Game.hp <= 0.0:
		dead = true
		Game.hp = 0.0
		velocity = Vector2.ZERO
		play_once("death")
		await sprite.animation_finished
		var screen = BOUNCE_BACK.new()
		screen.player = self
		get_tree().current_scene.add_child(screen)
	else:
		play_once("hurt")


func revive():
	dead = false
	busy = false
	Game.hp = Game.max_hp * 0.5
	invulnerable = 2.0
	sprite.play("idle")


func _draw():
	if spin_time > 0.0:
		var spin_reach = Game.melee_reach(Game.WEAPONS[Game.weapon_id].get("range", 0.0))
		draw_arc(Vector2.ZERO, spin_reach, 0.0, TAU, 40, Color(1, 1, 1, 0.5), 3)
	elif swing_time > 0.0:
		var reach = Game.melee_reach(Game.WEAPONS[Game.weapon_id].get("range", 0.0))
		draw_arc(Vector2.ZERO, reach, aim_dir.angle() - 0.9, aim_dir.angle() + 0.9, 16, Color(1, 1, 1, 0.7), 3)
```

---

## scripts/slash.gd

```gdscript
extends Area2D

var damage = 10.0
var reach = 70.0
var spin = false
var life = 0.15
var hit_list = []


func _ready():
	var shape = CollisionShape2D.new()
	var circle = CircleShape2D.new()
	if spin:
		circle.radius = reach
	else:
		circle.radius = reach * 0.5
	shape.shape = circle
	add_child(shape)
	body_entered.connect(_on_body_entered)


func _physics_process(delta):
	life -= delta
	if life <= 0.0:
		queue_free()


func _on_body_entered(body):
	if body.is_in_group("enemies") and not hit_list.has(body):
		hit_list.append(body)
		var push = (body.global_position - global_position).normalized() * 18.0
		body.take_damage(damage, push)
```

---

## scripts/bullet.gd

```gdscript
extends Area2D

var direction = Vector2.RIGHT
var speed = 600.0
var damage = 10.0
var pierce = 0
var hits = "enemies"
var art = ""
var style = "ball"
var life = 2.5


func _ready():
	var shape = CollisionShape2D.new()
	var circle = CircleShape2D.new()
	circle.radius = 6
	if art != "":
		circle.radius = 9
	shape.shape = circle
	add_child(shape)
	body_entered.connect(_on_body_entered)
	if art != "":
		var picture = Game.make_projectile(art)
		picture.rotation = direction.angle()
		add_child(picture)
	elif style == "arrow":
		var arrow = Sprite2D.new()
		arrow.texture = load(Game.ARROW)
		arrow.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		arrow.scale = Vector2(2.5, 2.5)
		arrow.rotation = direction.angle()
		add_child(arrow)


func _physics_process(delta):
	position += direction * speed * delta
	life -= delta
	if life <= 0.0:
		queue_free()


func _on_body_entered(body):
	if body.is_in_group(hits):
		body.take_damage(damage, direction * 12.0)
		if pierce <= 0:
			queue_free()
		else:
			pierce -= 1
	elif body.is_in_group("walls"):
		queue_free()


func _draw():
	if art != "":
		return
	if style == "ball":
		draw_circle(Vector2.ZERO, 7, Color.YELLOW.darkened(0.4))
		draw_circle(Vector2.ZERO, 5, Color.YELLOW)
	elif style == "tracer":
		var tail = -direction * 60.0
		draw_line(tail, Vector2.ZERO, Color(0.6, 0.9, 1.0, 0.5), 7)
		draw_line(tail, Vector2.ZERO, Color.WHITE, 3)
```

---

## scripts/enemy.gd

```gdscript
extends CharacterBody2D

const BULLET = preload("res://scenes/bullet.tscn")
const SIGHT_RADIUS = 480.0

var kind = "charger"
var anim_name = "goblin"
var health = 20.0
var max_health = 20.0
var radius = 14.0
var height = 50.0
var speed = 120.0
var touch_damage = 8.0
var knock_scale = 1.0
var sprite = null
var agent = null
var bar = ProgressBar.new()
var sees_player = false
var busy = false
var dead = false
var flash = 0.0
var hurt_timer = 0.0

var state = "walk"
var timer = 1.0
var dash_dir = Vector2.RIGHT
var shoot_timer = 1.5


func _ready():
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	add_to_group("enemies")
	setup()
	health = max_health
	radius = Game.ANIMS[anim_name]["radius"]
	height = Game.ANIMS[anim_name]["height"]

	var shape = CollisionShape2D.new()
	var circle = CircleShape2D.new()
	circle.radius = radius
	shape.shape = circle
	add_child(shape)

	sprite = Game.make_animated(anim_name)
	sprite.animation_finished.connect(_on_animation_finished)
	add_child(sprite)

	make_health_bar()

	agent = NavigationAgent2D.new()
	add_child(agent)

	var sight = Area2D.new()
	var sight_shape = CollisionShape2D.new()
	var sight_circle = CircleShape2D.new()
	sight_circle.radius = SIGHT_RADIUS
	sight_shape.shape = sight_circle
	sight.add_child(sight_shape)
	add_child(sight)
	sight.body_entered.connect(_on_sight_body_entered)

	set_physics_process(false)
	await get_tree().physics_frame
	set_physics_process(true)


func setup():
	var d = Game.dungeon - 1
	max_health = Game.enemy_health()
	touch_damage = 8.0 * Game.hard()
	if kind == "charger":
		anim_name = Game.CHARGERS[d]
		speed = 120.0
	else:
		anim_name = Game.SHOOTERS[d]
		speed = 90.0


func make_health_bar():
	var width = max(radius * 2.0, 30.0)
	var background = StyleBoxFlat.new()
	background.bg_color = Color(0.25, 0, 0)
	var fill = StyleBoxFlat.new()
	fill.bg_color = Color.RED
	bar.add_theme_stylebox_override("background", background)
	bar.add_theme_stylebox_override("fill", fill)
	bar.show_percentage = false
	bar.custom_minimum_size = Vector2(width, 5)
	bar.size = Vector2(width, 5)
	bar.position = Vector2(-width / 2.0, -height / 2.0 - 12.0)
	bar.max_value = max_health
	bar.value = health
	add_child(bar)


func _on_sight_body_entered(body):
	if body.is_in_group("player"):
		sees_player = true


func _physics_process(delta):
	if dead:
		return
	flash -= delta
	hurt_timer -= delta
	if flash > 0.0:
		sprite.modulate = Color(1, 0.4, 0.4)
	elif state == "windup":
		sprite.modulate = Color(1, 1, 0.4)
	else:
		sprite.modulate = Color.WHITE

	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	var to_player = player.global_position - global_position
	think(delta, player, to_player)


func play(name_of_animation):
	if not busy and sprite.animation != name_of_animation:
		sprite.play(name_of_animation)


func play_once(name_of_animation):
	busy = true
	sprite.play(name_of_animation)


func _on_animation_finished():
	if not dead:
		busy = false


# from ThinkWithGames (MIT)
func path_direction(target_position):
	agent.target_position = target_position
	var next_spot = agent.get_next_path_position()
	if next_spot.distance_to(global_position) < 1.0:
		return global_position.direction_to(target_position)
	return global_position.direction_to(next_spot)


func think(delta, player, to_player):
	if not sees_player:
		velocity = Vector2.ZERO
		play("idle")
		return
	if kind == "charger":
		do_charger(delta, player, to_player)
	else:
		do_shooter(delta, player, to_player)


func do_charger(delta, player, to_player):
	var dir = to_player.normalized()
	timer -= delta

	if state == "walk":
		velocity = path_direction(player.global_position) * speed
		play("run")
		if timer <= 0.0 and to_player.length() < 260.0:
			state = "windup"
			timer = 0.5
			Game.play_sound("windup", -6.0)
	elif state == "windup":
		velocity = Vector2.ZERO
		play("idle")
		if timer <= 0.0:
			state = "dash"
			timer = 0.4
			dash_dir = dir
			play_once("attack")
	elif state == "dash":
		velocity = dash_dir * speed * 3.5
		if timer <= 0.0:
			state = "walk"
			timer = 1.5
	move_and_slide()

	if to_player.length() < radius + 16.0:
		if state == "dash":
			player.take_damage(touch_damage * 2.0)
		else:
			player.take_damage(touch_damage)

	if state == "dash":
		sprite.flip_h = dash_dir.x < 0.0
	else:
		sprite.flip_h = to_player.x < 0.0


func do_shooter(delta, player, to_player):
	var dir = to_player.normalized()
	var dist = to_player.length()
	if dist > 320.0:
		velocity = path_direction(player.global_position) * speed
	elif dist < 200.0:
		velocity = -dir * speed
	else:
		velocity = Vector2.ZERO
	move_and_slide()
	if velocity.length() > 5.0:
		play("run")
	else:
		play("idle")
	sprite.flip_h = to_player.x < 0.0

	shoot_timer -= delta
	if shoot_timer <= 0.0:
		shoot_timer = 1.6 / Game.hard()
		play_once("attack")
		fire(dir, 8.0 * Game.hard())


func fire(dir, damage):
	var b = BULLET.instantiate()
	b.direction = dir
	b.speed = 260.0
	b.damage = damage
	b.hits = "player"
	b.art = Game.PROJECTILE_BY_DUNGEON[Game.dungeon - 1]
	get_tree().current_scene.add_child(b)
	b.global_position = global_position + dir * (radius + 10.0)
	Game.play_sound("enemy_shoot", -10.0)


func take_damage(amount, push = Vector2.ZERO):
	if dead:
		return
	health -= amount
	bar.value = max(health, 0.0)
	flash = 0.1
	sees_player = true
	Game.play_sound("hit", -6.0)
	if push != Vector2.ZERO and health > 0.0:
		var tween = create_tween()
		tween.tween_property(self, "global_position", global_position + push * knock_scale, 0.1)
	if health <= 0.0:
		die()
	elif hurt_timer <= 0.0 and not busy:
		hurt_timer = 0.8
		play_once("hurt")


func die():
	if dead:
		return
	dead = true
	bar.visible = false
	Game.play_sound("enemy_die", -4.0)
	Game.on_enemy_killed()
	remove_from_group("enemies")
	collision_layer = 0
	collision_mask = 0
	velocity = Vector2.ZERO
	sprite.modulate = Color.WHITE
	play_once("death")
	await sprite.animation_finished
	queue_free()
```

---

## scripts/boss.gd

```gdscript
extends "res://scripts/enemy.gd"

const SHOW_STATE = true
const FSM = preload("res://scripts/boss/finite_state_machine.gd")
const IDLE = preload("res://scripts/boss/idle.gd")
const FOLLOW = preload("res://scripts/boss/follow.gd")
const ATTACK = preload("res://scripts/boss/attack.gd")
const TELEPORT = preload("res://scripts/boss/teleport.gd")
const SPAWN_MINION = preload("res://scripts/boss/spawn_minion.gd")
const DEATH = preload("res://scripts/boss/death.gd")

const ATTACK_RANGES = [280.0, 450.0, 400.0]
const FAR_RANGES = [500.0, 650.0, 600.0]
const FAR_STATES = ["Teleport", "Teleport", "SpawnMinion"]

var boss_type = 1
var attack_range = 300.0
var far_range = 600.0
var far_state = "Teleport"
var target = null
var direction = Vector2.ZERO
var debug_label = Label.new()
var fsm = null


func setup():
	boss_type = Game.dungeon
	anim_name = Game.BOSSES[boss_type - 1]["anim"]
	max_health = Game.boss_health()
	touch_damage = 12.0 * Game.hard()
	speed = 80.0
	if boss_type == 1:
		speed = 130.0
	attack_range = ATTACK_RANGES[boss_type - 1]
	far_range = FAR_RANGES[boss_type - 1]
	far_state = FAR_STATES[boss_type - 1]
	knock_scale = 0.2


func _ready():
	super()
	debug_label.visible = SHOW_STATE
	debug_label.position = Vector2(-40, -height / 2.0 - 40.0)
	add_child(debug_label)

	var detection = Area2D.new()
	var shape = CollisionShape2D.new()
	var circle = CircleShape2D.new()
	circle.radius = 520.0
	shape.shape = circle
	detection.add_child(shape)
	add_child(detection)

	fsm = FSM.new()
	var states = [["Idle", IDLE], ["Follow", FOLLOW], ["Attack", ATTACK], ["Teleport", TELEPORT], ["SpawnMinion", SPAWN_MINION], ["Death", DEATH]]
	var idle = null
	for entry in states:
		var state = entry[1].new()
		state.name = entry[0]
		state.boss = self
		fsm.add_child(state)
		if entry[0] == "Idle":
			idle = state
	detection.body_entered.connect(idle._on_player_detection_body_entered)
	add_child(fsm)


func think(_delta, player, to_player):
	target = player
	direction = to_player


func follow_player():
	if boss_type == 2:
		velocity = direction.normalized().rotated(PI / 2) * speed
	else:
		velocity = path_direction(target.global_position) * speed
	move_and_slide()
	play("run")
	sprite.flip_h = direction.x < 0.0
	touch_player(1.0)


func touch_player(multiplier):
	if direction.length() < radius + 16.0:
		target.take_damage(touch_damage * multiplier)


func ring(count):
	for i in count:
		fire(Vector2.from_angle(TAU * i / count), 9.0 * Game.hard())


func fan(count):
	var middle = direction.normalized()
	for i in count:
		var angle = (i - (count - 1) / 2.0) * 0.25
		fire(middle.rotated(angle), 10.0 * Game.hard())


func summon_minions():
	if get_tree().get_nodes_in_group("enemies").size() > 6:
		return
	for i in 2:
		var m = load("res://scenes/enemy.tscn").instantiate()
		m.kind = "charger"
		get_tree().current_scene.add_child(m)
		m.global_position = global_position + Vector2.from_angle(randf() * TAU) * 90.0
		m.sees_player = true


func inside_room(spot):
	return Vector2(clamp(spot.x, 160.0, 992.0), clamp(spot.y, 160.0, 520.0))


func die():
	for e in get_tree().get_nodes_in_group("enemies"):
		if e != self:
			e.queue_free()
	fsm.change_state("Death")
	super()
```

---

## scripts/chest.gd

```gdscript
extends Area2D

const DROP = preload("res://scenes/weapon_drop.tscn")

var opened = false
var sprite = null


func _ready():
	var shape = CollisionShape2D.new()
	var rect = RectangleShape2D.new()
	rect.size = Vector2(40, 40)
	shape.shape = rect
	add_child(shape)
	sprite = Game.make_sprite(Game.DT + "chest_full_open_anim_f0.png", 52)
	add_child(sprite)
	body_entered.connect(_on_body_entered)


func _on_body_entered(body):
	if opened or not body.is_in_group("player"):
		return
	opened = true
	Game.play_sound("chest")
	sprite.texture = load(Game.DT + "chest_full_open_anim_f2.png")

	var old_weapon = Game.weapon_id
	Game.weapon_id = Game.random_weapon()
	var drop = DROP.instantiate()
	drop.weapon_id = old_weapon
	drop.position = position + Vector2(0, 80)
	get_parent().add_child.call_deferred(drop)

	var label = Label.new()
	label.text = "You got: " + Game.weapon_id.to_upper() + "!"
	label.position = Vector2(-70, -60)
	add_child(label)
	await get_tree().create_timer(2.0).timeout
	label.queue_free()
```

---

## scripts/weapon_drop.gd

```gdscript
extends Area2D

var weapon_id = "pistol"
var sprite = null
var label = Label.new()
var near = false
var time = 0.0


func _ready():
	var shape = CollisionShape2D.new()
	var circle = CircleShape2D.new()
	circle.radius = 34
	shape.shape = circle
	add_child(shape)

	sprite = Sprite2D.new()
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	add_child(sprite)

	label.position = Vector2(-70, -64)
	label.visible = false
	add_child(label)

	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	refresh()


func refresh():
	sprite.texture = load(Game.WEAPONS[weapon_id]["art"])
	Game.fit_sprite(sprite, 44)
	label.text = "[E] take " + weapon_id.to_upper()


func _process(delta):
	time += delta
	sprite.position.y = sin(time * 3.0) * 3.0
	label.visible = near
	if near and Input.is_action_just_pressed("interact"):
		var old = Game.weapon_id
		Game.weapon_id = weapon_id
		weapon_id = old
		Game.play_sound("click")
		refresh()


func _on_body_entered(body):
	if body.is_in_group("player"):
		near = true


func _on_body_exited(body):
	if body.is_in_group("player"):
		near = false
```

---

## scripts/door.gd

```gdscript
extends Area2D

var used = false


func _ready():
	var shape = CollisionShape2D.new()
	var rect = RectangleShape2D.new()
	rect.size = Vector2(40, 40)
	shape.shape = rect
	add_child(shape)
	add_child(Game.make_sprite(Game.DT + "floor_ladder.png", 56))
	body_entered.connect(_on_body_entered)


func _on_body_entered(body):
	if body.is_in_group("player") and not used:
		used = true
		Game.go_next_floor.call_deferred()
```

---

## scripts/hud.gd

```gdscript
extends CanvasLayer

var hp_bar = ProgressBar.new()
var hp_label = Label.new()
var info = Label.new()
var icons = HBoxContainer.new()
var icons_shown = 0
var weapon_icon = TextureRect.new()
var weapon_name = Label.new()
var weapon_shown = ""


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

	info.position = Vector2(24, 2)
	add_child(info)

	hp_bar.position = Vector2(24, 26)
	hp_bar.size = Vector2(300, 20)
	hp_bar.show_percentage = false
	var fill = StyleBoxFlat.new()
	fill.bg_color = Color(0.85, 0.15, 0.15)
	hp_bar.add_theme_stylebox_override("fill", fill)
	add_child(hp_bar)

	hp_label.position = Vector2(140, 24)
	add_child(hp_label)

	icons.position = Vector2(700, 2)
	add_child(icons)

	weapon_icon.position = Vector2(334, 20)
	weapon_icon.custom_minimum_size = Vector2(30, 30)
	weapon_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	weapon_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	weapon_icon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	add_child(weapon_icon)
	weapon_name.position = Vector2(372, 22)
	add_child(weapon_name)


func _process(_delta):
	hp_bar.max_value = Game.max_hp
	hp_bar.value = Game.hp
	hp_label.text = "%d / %d" % [Game.hp, Game.max_hp]

	var floor_text = "Floor %d/%d" % [Game.floor_number, Game.FLOORS_PER_DUNGEON]
	if Game.floor_number == Game.FLOORS_PER_DUNGEON:
		floor_text = "BOSS: " + Game.BOSSES[min(Game.dungeon, Game.TOTAL_DUNGEONS) - 1]["name"]
	info.text = "Dungeon %d/%d   %s" % [min(Game.dungeon, Game.TOTAL_DUNGEONS), Game.TOTAL_DUNGEONS, floor_text]

	if weapon_shown != Game.weapon_id:
		weapon_shown = Game.weapon_id
		weapon_name.text = Game.weapon_id.to_upper()
		weapon_icon.texture = load(Game.WEAPONS[Game.weapon_id]["art"])

	if icons_shown != Game.owned_powerups.size():
		icons_shown = Game.owned_powerups.size()
		for old in icons.get_children():
			old.queue_free()
		for id in Game.owned_powerups:
			icons.add_child(make_icon(Game.POWERUPS[id]["icon"], 40))


func make_icon(path, size):
	var t = TextureRect.new()
	t.texture = load(path)
	t.custom_minimum_size = Vector2(size, size)
	t.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	t.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	t.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	return t


func show_powerup(id):
	get_tree().paused = true
	Game.play_sound("powerup")

	var panel = Panel.new()
	panel.size = Vector2(440, 330)
	panel.position = Vector2(356, 150)
	add_child(panel)

	var box = VBoxContainer.new()
	box.position = Vector2(20, 20)
	box.size = Vector2(400, 290)
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	panel.add_child(box)

	var title = Label.new()
	title.text = "DUNGEON %d CLEARED!" % Game.dungeon
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(title)

	if id != "":
		box.add_child(make_icon(Game.POWERUPS[id]["icon"], 80))
		var name_label = Label.new()
		name_label.text = Game.POWERUPS[id]["name"]
		name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		box.add_child(name_label)
		var text_label = Label.new()
		text_label.text = Game.POWERUPS[id]["text"]
		text_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		box.add_child(text_label)

	var button = Button.new()
	button.text = "Next dungeon"
	if Game.dungeon == Game.TOTAL_DUNGEONS:
		button.text = "Finish the game"
	button.pressed.connect(_on_continue.bind(id))
	box.add_child(button)


func _on_continue(id):
	get_tree().paused = false
	Game.finish_dungeon(id)
```

---

## scripts/bounce_back.gd

```gdscript
extends CanvasLayer

const BAR_POS = Vector2(226, 330)
const BAR_SIZE = Vector2(700, 60)
const RED_WIDTH = 60.0
const SPEED = 450.0

var player = null
var arrow = Polygon2D.new()
var red = ColorRect.new()
var result = Label.new()
var red_width = RED_WIDTH
var arrow_x = 0.0
var direction = 1.0
var finished = false
var wait = 0.4


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true

	var dim = ColorRect.new()
	dim.color = Color(0, 0, 0, 0.65)
	dim.size = Vector2(1152, 648)
	add_child(dim)

	var title = Label.new()
	title.text = "do you want to BOUNCE BACK?"
	title.add_theme_font_size_override("font_size", 40)
	title.position = Vector2(250, 150)
	add_child(title)

	var hint = Label.new()
	hint.text = "click when the arrow is over the red square"
	hint.position = Vector2(380, 215)
	add_child(hint)

	var border = ColorRect.new()
	border.color = Color.WHITE
	border.position = BAR_POS - Vector2(4, 4)
	border.size = BAR_SIZE + Vector2(8, 8)
	add_child(border)

	var bar = ColorRect.new()
	bar.color = Color.BLACK
	bar.position = BAR_POS
	bar.size = BAR_SIZE
	add_child(bar)

	red_width = max(RED_WIDTH / pow(2.0, Game.bounces), 2.0)
	red.color = Color(0.9, 0.1, 0.1)
	red.size = Vector2(red_width, BAR_SIZE.y)
	red.position = Vector2(BAR_POS.x + randf_range(0.0, BAR_SIZE.x - red_width), BAR_POS.y)
	add_child(red)

	arrow.polygon = PackedVector2Array([Vector2(-16, -26), Vector2(16, -26), Vector2(0, 0)])
	arrow.color = Color.WHITE
	arrow.position = Vector2(BAR_POS.x, BAR_POS.y - 10)
	add_child(arrow)

	result.add_theme_font_size_override("font_size", 32)
	result.position = Vector2(420, 430)
	add_child(result)


func _process(delta):
	wait -= delta
	if finished:
		return
	arrow_x += direction * SPEED * delta
	if arrow_x > BAR_SIZE.x:
		arrow_x = BAR_SIZE.x
		direction = -1.0
	elif arrow_x < 0.0:
		arrow_x = 0.0
		direction = 1.0
	arrow.position.x = BAR_POS.x + arrow_x


func _input(event):
	if finished or wait > 0.0:
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		stop()


func stop():
	finished = true
	var red_left = red.position.x - BAR_POS.x
	var hit = arrow_x >= red_left and arrow_x <= red_left + red_width
	if hit:
		result.text = "BOUNCED BACK!"
		Game.play_sound("powerup")
	else:
		result.text = "too late..."
	await get_tree().create_timer(0.9).timeout
	if hit:
		get_tree().paused = false
		Game.bounces += 1
		player.revive()
		queue_free()
	else:
		Game.game_over()
```

---

## scripts/boss/state.gd

```gdscript
extends Node2D
class_name State
# from 16BitDev

var boss = null


func _ready():
	set_physics_process(false)


func enter():
	set_physics_process(true)


func exit():
	set_physics_process(false)


func transition():
	pass


func _physics_process(_delta):
	transition()
	boss.debug_label.text = name
```

---

## scripts/boss/finite_state_machine.gd

```gdscript
extends Node2D
# from 16BitDev

var current_state: State
var previous_state: State


func _ready():
	current_state = get_child(0) as State
	previous_state = current_state
	current_state.enter()


func change_state(state_name):
	current_state = get_node(state_name) as State
	current_state.enter()

	previous_state.exit()
	previous_state = current_state
```

---

## scripts/boss/idle.gd

```gdscript
extends State

var player_entered = false


func _on_player_detection_body_entered(body):
	if body.is_in_group("player"):
		player_entered = true


func transition():
	if player_entered:
		get_parent().change_state("Follow")
```

---

## scripts/boss/follow.gd

```gdscript
extends State

var wait = 1.0


func enter():
	super.enter()
	wait = 1.2 / Game.hard()


func _physics_process(delta):
	wait -= delta
	boss.follow_player()
	super(delta)


func transition():
	if wait > 0.0:
		return
	var distance = boss.direction.length()
	if distance < boss.attack_range:
		get_parent().change_state("Attack")
	elif distance > boss.far_range:
		get_parent().change_state(boss.far_state)
```

---

## scripts/boss/attack.gd

```gdscript
extends State

var can_transition = false
var phase = "windup"
var timer = 0.0
var dash_dir = Vector2.RIGHT


func enter():
	super.enter()
	can_transition = false
	if boss.boss_type == 1:
		phase = "windup"
		timer = 0.6
		boss.state = "windup"
		boss.velocity = Vector2.ZERO
		boss.play("idle")
		Game.play_sound("windup", -6.0)
	else:
		volleys()


func exit():
	boss.state = "walk"
	super.exit()


func volleys():
	var sizes = [3, 3, 5]
	if boss.boss_type == 2:
		sizes = [10, 10, 14]
	for count in sizes:
		if boss.dead:
			return
		boss.play_once("attack")
		if boss.boss_type == 2:
			boss.ring(count)
		else:
			boss.fan(count)
		await get_tree().create_timer(0.7 / Game.hard()).timeout
	can_transition = true


func _physics_process(delta):
	if boss.boss_type == 1:
		dash(delta)
	super(delta)


func dash(delta):
	timer -= delta
	if phase == "windup":
		boss.sprite.flip_h = boss.direction.x < 0.0
		if timer <= 0.0:
			phase = "dash"
			timer = 0.45
			dash_dir = boss.direction.normalized()
			boss.state = "dash"
			boss.play_once("attack")
	elif phase == "dash":
		boss.velocity = dash_dir * boss.speed * 3.5
		boss.move_and_slide()
		boss.touch_player(2.0)
		boss.sprite.flip_h = dash_dir.x < 0.0
		if timer <= 0.0:
			phase = "done"
			can_transition = true


func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("Follow")
```

---

## scripts/boss/teleport.gd

```gdscript
extends State

var can_transition = false


func enter():
	super.enter()
	can_transition = false
	boss.velocity = Vector2.ZERO
	boss.play_once("attack")
	await boss.sprite.animation_finished
	if boss.dead:
		return
	boss.global_position = boss.inside_room(boss.target.global_position + Vector2.from_angle(randf() * TAU) * 140.0)
	can_transition = true


func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("Attack")
```

---

## scripts/boss/spawn_minion.gd

```gdscript
extends State

var can_transition = false


func enter():
	super.enter()
	can_transition = false
	boss.velocity = Vector2.ZERO
	boss.play_once("attack")
	await boss.sprite.animation_finished
	if boss.dead:
		return
	boss.summon_minions()
	can_transition = true


func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("Follow")
```

---

## scripts/boss/death.gd

```gdscript
extends State


func enter():
	super.enter()
	boss.velocity = Vector2.ZERO
```

---
