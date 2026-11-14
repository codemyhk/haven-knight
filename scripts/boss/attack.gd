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
