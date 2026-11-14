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
