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
