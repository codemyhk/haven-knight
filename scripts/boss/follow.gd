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
