extends Node2D

const DT_FOLDER = "res://assets/itch/dungeontileset-ii/0x72_DungeonTilesetII_v1.7/"
const KENNEY = "res://assets/tiny-dungeon/Tiles/"
const ICONS = "res://assets/icons/"
const PAGES = ["walls and floors", "weapons", "creatures", "Kenney tiles", "big sheets"]
const SCENERY = ["wall_", "floor", "column", "crate", "edge", "hole", "skull", "doors_", "button", "lever", "chest", "flask", "coin", "bomb", "ui_"]
const SHEETS = [
	[DT_FOLDER + "0x72_DungeonTilesetII_v1.7.png", "0x72 DungeonTileset II, everything"],
	[DT_FOLDER + "atlas_floor-16x16.png", "0x72 floors"],
	[DT_FOLDER + "atlas_walls_low-16x16.png", "0x72 low walls"],
	[DT_FOLDER + "atlas_walls_high-16x32.png", "0x72 high walls"],
	["res://assets/tiny-dungeon/Tilemap/tilemap.png", "Kenney Tiny Dungeon"],
]

var content = Node2D.new()
var camera = Camera2D.new()
var title = Label.new()
var page_height = 648.0


func _ready():
	RenderingServer.set_default_clear_color(Color(0.2, 0.22, 0.28))
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	add_child(content)
	camera.position = Vector2(576, 324)
	add_child(camera)

	var layer = CanvasLayer.new()
	var strip = ColorRect.new()
	strip.color = Color(0, 0, 0, 0.75)
	strip.size = Vector2(1152, 34)
	layer.add_child(strip)
	title.position = Vector2(12, 4)
	layer.add_child(title)
	add_child(layer)

	var start = 0
	var args = OS.get_cmdline_user_args()
	if args.size() > 0:
		start = int(args[0])
	show_page(start)


func show_page(n):
	for old in content.get_children():
		old.queue_free()
	title.text = "page %d/5: %s     (keys 1-5 change page, wheel or arrows scroll, + and - zoom)" % [n + 1, PAGES[n]]
	camera.position = Vector2(576, 324 / camera.zoom.y)
	if n == 0:
		grid(find_frames(true), 8, Vector2(140, 150))
	elif n == 1:
		var items = []
		for item in find_frames(false):
			if item[0].begins_with("weapon_"):
				items.append(item)
		for file in DirAccess.get_files_at(ICONS):
			if file.ends_with(".png"):
				items.append(["icon: " + file.get_basename(), [ICONS + file]])
		grid(items, 8, Vector2(140, 150))
	elif n == 2:
		var items = []
		for item in find_frames(false):
			if not item[0].begins_with("weapon_") and not is_scenery(item[0]):
				items.append(item)
		grid(items, 8, Vector2(140, 150))
	elif n == 3:
		var items = []
		for i in 132:
			items.append(["tile " + str(i), [KENNEY + "tile_%04d.png" % i]])
		grid(items, 10, Vector2(110, 120))
	else:
		sheets()


func is_scenery(base):
	for prefix in SCENERY:
		if base.begins_with(prefix):
			return true
	return false


func find_frames(scenery_only):
	var folder = DT_FOLDER + "frames/"
	var rx = RegEx.create_from_string("(_anim)?_f(\\d+)$")
	var groups = {}
	for file in DirAccess.get_files_at(folder):
		if not file.ends_with(".png"):
			continue
		var base = rx.sub(file.get_basename(), "")
		if not groups.has(base):
			groups[base] = []
		groups[base].append(folder + file)
	var result = []
	var names = groups.keys()
	names.sort()
	for base in names:
		if scenery_only and not is_scenery(base):
			continue
		var paths = groups[base]
		paths.sort()
		result.append([base, paths])
	return result


func grid(items, columns, cell):
	for i in items.size():
		var origin = Vector2(20, 50) + Vector2((i % columns) * cell.x, floori(i / float(columns)) * cell.y)
		add_item(items[i][0], items[i][1], origin, cell)
	page_height = 50 + ceil(items.size() / float(columns)) * cell.y + 30


func add_item(label_text, paths, origin, cell):
	var first = load(paths[0])
	var scale_to = min(5.0, 90.0 / max(first.get_width(), first.get_height()))
	var picture
	if paths.size() > 1:
		var frames = SpriteFrames.new()
		frames.set_animation_speed("default", 8.0)
		for path in paths:
			frames.add_frame("default", load(path))
		picture = AnimatedSprite2D.new()
		picture.sprite_frames = frames
		picture.play("default")
	else:
		picture = Sprite2D.new()
		picture.texture = first
	picture.scale = Vector2.ONE * scale_to
	picture.position = origin + Vector2(cell.x / 2.0, 52)
	content.add_child(picture)

	var label = Label.new()
	label.text = label_text
	label.add_theme_font_size_override("font_size", 11)
	label.autowrap_mode = TextServer.AUTOWRAP_ARBITRARY
	label.custom_minimum_size = Vector2(cell.x - 8, 0)
	label.position = origin + Vector2(4, 104)
	content.add_child(label)


func sheets():
	var y = 50.0
	for sheet in SHEETS:
		var texture = load(sheet[0])
		var scale_to = min(2.0, 1100.0 / texture.get_width())
		var label = Label.new()
		label.text = "%s   (%d x %d)" % [sheet[1], texture.get_width(), texture.get_height()]
		label.position = Vector2(20, y)
		content.add_child(label)
		var picture = Sprite2D.new()
		picture.texture = texture
		picture.centered = false
		picture.scale = Vector2.ONE * scale_to
		picture.position = Vector2(20, y + 28)
		content.add_child(picture)
		y += texture.get_height() * scale_to + 70
	page_height = y


func _unhandled_input(event):
	if event is InputEventKey and event.pressed:
		var n = event.keycode - KEY_1
		if n >= 0 and n < PAGES.size():
			show_page(n)
		elif event.keycode == KEY_EQUAL or event.keycode == KEY_KP_ADD:
			camera.zoom = Vector2.ONE * min(camera.zoom.x * 1.25, 4.0)
		elif event.keycode == KEY_MINUS or event.keycode == KEY_KP_SUBTRACT:
			camera.zoom = Vector2.ONE * max(camera.zoom.x / 1.25, 0.4)
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			camera.position.y -= 120.0
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			camera.position.y += 120.0


func _process(delta):
	var move = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	camera.position += move * 700.0 * delta / camera.zoom.x
	var half_screen = 324.0 / camera.zoom.y
	camera.position.y = clamp(camera.position.y, half_screen, max(page_height - half_screen, half_screen))
	camera.position.x = clamp(camera.position.x, 576.0 / camera.zoom.x, max(1152.0 - 576.0 / camera.zoom.x, 576.0 / camera.zoom.x))
