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
