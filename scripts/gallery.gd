extends Node2D

const ANIMS = ["idle", "run", "attack", "hurt", "death"]
var label = Label.new()


func _ready():
	label.position = Vector2(20, 10)
	label.text = "animation: idle   (press 1-5: idle, run, attack, hurt, death)"
	add_child(label)
	for child in get_children():
		if child is AnimatedSprite2D:
			for anim in ANIMS:
				child.sprite_frames.set_animation_loop(anim, true)


func _unhandled_input(event):
	if event is InputEventKey and event.pressed:
		var i = event.keycode - KEY_1
		if i >= 0 and i < ANIMS.size():
			for child in get_children():
				if child is AnimatedSprite2D:
					child.play(ANIMS[i])
			label.text = "animation: " + ANIMS[i] + "   (press 1-5: idle, run, attack, hurt, death)"
