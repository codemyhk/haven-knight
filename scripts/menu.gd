extends Control

func _ready():
	var background = ColorRect.new()
	background.color = Color(0.08, 0.08, 0.12)
	background.size = Vector2(1152, 648)
	add_child(background)

	var title = Label.new()
	title.text = "HAVEN KNIGHT - pick your hero"
	title.add_theme_font_size_override("font_size", 32)
	title.position = Vector2(300, 60)
	add_child(title)

	if Game.message != "":
		var msg = Label.new()
		msg.text = Game.message
		msg.add_theme_font_size_override("font_size", 22)
		msg.position = Vector2(380, 130)
		add_child(msg)

	var x = 260
	for id in Game.CHARACTERS:
		var info = Game.CHARACTERS[id]

		var picture = Game.make_animated(info["anim"])
		picture.scale *= 2.0
		picture.position = Vector2(x + 120, 270)
		add_child(picture)

		var button = Button.new()
		button.text = info["name"]
		button.position = Vector2(x + 20, 360)
		button.size = Vector2(200, 50)
		button.pressed.connect(_on_pick.bind(id))
		add_child(button)

		var buff = Label.new()
		buff.text = info["buff"]
		buff.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		buff.custom_minimum_size = Vector2(240, 0)
		buff.position = Vector2(x, 420)
		add_child(buff)

		x += 400

	var help = Label.new()
	help.text = "WASD move   Mouse aim   Left click attack   Beat 3 dungeons (7 floors each)"
	help.position = Vector2(300, 580)
	add_child(help)


func _on_pick(id):
	Game.play_sound("click")
	Game.start_run(id)
	Game.go_to_floor_scene()
