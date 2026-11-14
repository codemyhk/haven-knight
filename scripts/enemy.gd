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
