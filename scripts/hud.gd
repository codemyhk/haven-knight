extends CanvasLayer

var hp_bar = ProgressBar.new()
var hp_label = Label.new()
var info = Label.new()
var icons = HBoxContainer.new()
var icons_shown = 0
var weapon_icon = TextureRect.new()
var weapon_name = Label.new()
var weapon_shown = ""


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

	info.position = Vector2(24, 2)
	add_child(info)

	hp_bar.position = Vector2(24, 26)
	hp_bar.size = Vector2(300, 20)
	hp_bar.show_percentage = false
	var fill = StyleBoxFlat.new()
	fill.bg_color = Color(0.85, 0.15, 0.15)
	hp_bar.add_theme_stylebox_override("fill", fill)
	add_child(hp_bar)

	hp_label.position = Vector2(140, 24)
	add_child(hp_label)

	icons.position = Vector2(700, 2)
	add_child(icons)

	weapon_icon.position = Vector2(334, 20)
	weapon_icon.custom_minimum_size = Vector2(30, 30)
	weapon_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	weapon_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	weapon_icon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	add_child(weapon_icon)
	weapon_name.position = Vector2(372, 22)
	add_child(weapon_name)


func _process(_delta):
	hp_bar.max_value = Game.max_hp
	hp_bar.value = Game.hp
	hp_label.text = "%d / %d" % [Game.hp, Game.max_hp]

	var floor_text = "Floor %d/%d" % [Game.floor_number, Game.FLOORS_PER_DUNGEON]
	if Game.floor_number == Game.FLOORS_PER_DUNGEON:
		floor_text = "BOSS: " + Game.BOSSES[min(Game.dungeon, Game.TOTAL_DUNGEONS) - 1]["name"]
	info.text = "Dungeon %d/%d   %s" % [min(Game.dungeon, Game.TOTAL_DUNGEONS), Game.TOTAL_DUNGEONS, floor_text]

	if weapon_shown != Game.weapon_id:
		weapon_shown = Game.weapon_id
		weapon_name.text = Game.weapon_id.to_upper()
		weapon_icon.texture = load(Game.WEAPONS[Game.weapon_id]["art"])

	if icons_shown != Game.owned_powerups.size():
		icons_shown = Game.owned_powerups.size()
		for old in icons.get_children():
			old.queue_free()
		for id in Game.owned_powerups:
			icons.add_child(make_icon(Game.POWERUPS[id]["icon"], 40))


func make_icon(path, size):
	var t = TextureRect.new()
	t.texture = load(path)
	t.custom_minimum_size = Vector2(size, size)
	t.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	t.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	t.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	return t


func show_powerup(id):
	get_tree().paused = true
	Game.play_sound("powerup")

	var panel = Panel.new()
	panel.size = Vector2(440, 330)
	panel.position = Vector2(356, 150)
	add_child(panel)

	var box = VBoxContainer.new()
	box.position = Vector2(20, 20)
	box.size = Vector2(400, 290)
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	panel.add_child(box)

	var title = Label.new()
	title.text = "DUNGEON %d CLEARED!" % Game.dungeon
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(title)

	if id != "":
		box.add_child(make_icon(Game.POWERUPS[id]["icon"], 80))
		var name_label = Label.new()
		name_label.text = Game.POWERUPS[id]["name"]
		name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		box.add_child(name_label)
		var text_label = Label.new()
		text_label.text = Game.POWERUPS[id]["text"]
		text_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		box.add_child(text_label)

	var button = Button.new()
	button.text = "Next dungeon"
	if Game.dungeon == Game.TOTAL_DUNGEONS:
		button.text = "Finish the game"
	button.pressed.connect(_on_continue.bind(id))
	box.add_child(button)


func _on_continue(id):
	get_tree().paused = false
	Game.finish_dungeon(id)
