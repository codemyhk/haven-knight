extends State

var player_entered = false


func _on_player_detection_body_entered(body):
	if body.is_in_group("player"):
		player_entered = true


func transition():
	if player_entered:
		get_parent().change_state("Follow")
