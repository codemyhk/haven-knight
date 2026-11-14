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
