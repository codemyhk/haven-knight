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
