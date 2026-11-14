extends Node2D

const PLAYER = preload("res://scenes/player.tscn")
const ENEMY = preload("res://scenes/enemy.tscn")
const BOSS = preload("res://scenes/boss.tscn")
const CHEST = preload("res://scenes/chest.tscn")
const DOOR = preload("res://scenes/door.tscn")
const HUD = preload("res://scripts/hud.gd")

const TILE = 48
const ROOM = Rect2(96, 96, 960, 480)

const OBSTACLES = [
	{"picture": "crate",  "size": 72, "lift": -16, "box": Vector2(40, 40)},
	{"picture": "column", "size": 96, "lift": -28, "box": Vector2(30, 30)},
]

var hud = null
var cleared = false
var obstacle_spots = []
var obstacle_boxes = []


func _ready():
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	y_sort_enabled = true
	build_tiles()
	build_walls()

	var player = PLAYER.instantiate()
	add_child(player)
	player.global_position = ROOM.get_center() + Vector2(0, 150)

	hud = HUD.new()
	add_child(hud)

	if Game.floor_number == 1:
		Game.play_sound("start")
	if Game.floor_number == Game.FLOORS_PER_DUNGEON:
		Game.play_sound("boss")
		build_navigation()
		spawn_boss()
	else:
		spawn_obstacles()
		build_navigation()
		spawn_enemies(2 + Game.floor_number)

	if Game.floor_number == Game.chest_floor:
		var chest = CHEST.instantiate()
		add_child(chest)
		chest.global_position = ROOM.position + Vector2(100, 100)

	scatter_decor()


func _process(_delta):
	if cleared:
		return
	if get_tree().get_nodes_in_group("enemies").is_empty():
		cleared = true
		if Game.floor_number == Game.FLOORS_PER_DUNGEON:
			hud.show_powerup(Game.pick_random_powerup())
		else:
			Game.play_sound("door")
			var door = DOOR.instantiate()
			add_child(door)
			door.global_position = Vector2(ROOM.get_center().x, ROOM.position.y + 40)


func spawn_enemies(count):
	for i in count:
		var e = ENEMY.instantiate()
		if i % 2 == 0:
			e.kind = "charger"
		else:
			e.kind = "shooter"
		add_child(e)
		var spot = Vector2.ZERO
		for attempt in 20:
			spot = Vector2(
				randf_range(ROOM.position.x + 60, ROOM.end.x - 60),
				randf_range(ROOM.position.y + 60, ROOM.position.y + 200))
			if not touches_obstacle(spot, 50.0):
				break
		e.global_position = spot


func spawn_obstacles():
	var count = randi_range(5, 9)
	for i in count:
		for attempt in 30:
			var gx = randi_range(1, 18)
			var gy = randi_range(1, 8)
			var center = ROOM.position + (Vector2(gx, gy) + Vector2(0.5, 0.5)) * TILE
			if obstacle_spot_is_free(center):
				place_obstacle(center)
				break


func obstacle_spot_is_free(center):
	if center.distance_to(ROOM.get_center() + Vector2(0, 150)) < 120.0:
		return false
	if center.distance_to(Vector2(ROOM.get_center().x, ROOM.position.y + 40)) < 110.0:
		return false
	if center.distance_to(ROOM.position + Vector2(100, 100)) < 110.0:
		return false
	return not touches_obstacle(center, 110.0)


func touches_obstacle(spot, distance):
	for other in obstacle_spots:
		if spot.distance_to(other) < distance:
			return true
	return false


func place_obstacle(center):
	obstacle_spots.append(center)
	var kind = OBSTACLES.pick_random()
	obstacle_boxes.append(Rect2(center - kind["box"] / 2.0, kind["box"]))
	var body = StaticBody2D.new()
	body.add_to_group("walls")
	var shape = CollisionShape2D.new()
	var rect = RectangleShape2D.new()
	rect.size = kind["box"]
	shape.shape = rect
	body.add_child(shape)
	var picture = Game.make_sprite(Game.DT + kind["picture"] + ".png", kind["size"])
	picture.position.y = kind["lift"]
	body.add_child(picture)
	body.position = center
	add_child(body)


func build_navigation():
	var polygon = NavigationPolygon.new()
	polygon.agent_radius = 16.0
	var source = NavigationMeshSourceGeometryData2D.new()
	source.add_traversable_outline(corners(ROOM))
	for box in obstacle_boxes:
		source.add_obstruction_outline(corners(box))
	NavigationServer2D.bake_from_source_geometry_data(polygon, source)
	var region = NavigationRegion2D.new()
	region.navigation_polygon = polygon
	add_child(region)


func corners(rect):
	return PackedVector2Array([
		rect.position, Vector2(rect.end.x, rect.position.y),
		rect.end, Vector2(rect.position.x, rect.end.y)])


func spawn_boss():
	var b = BOSS.instantiate()
	add_child(b)
	b.global_position = Vector2(ROOM.get_center().x, ROOM.position.y + 110)


func build_walls():
	var t = 48.0
	wall(Rect2(ROOM.position.x - t, ROOM.position.y - t, ROOM.size.x + 2 * t, t))
	wall(Rect2(ROOM.position.x - t, ROOM.end.y, ROOM.size.x + 2 * t, t))
	wall(Rect2(ROOM.position.x - t, ROOM.position.y, t, ROOM.size.y))
	wall(Rect2(ROOM.end.x, ROOM.position.y, t, ROOM.size.y))


func wall(r):
	var body = StaticBody2D.new()
	body.add_to_group("walls")
	var shape = CollisionShape2D.new()
	var rect = RectangleShape2D.new()
	rect.size = r.size
	shape.shape = rect
	body.add_child(shape)
	body.position = r.get_center()
	add_child(body)


func build_tiles():
	var tint = Game.DUNGEON_TINTS[Game.dungeon - 1]
	var background = ColorRect.new()
	background.color = Color(0.04, 0.04, 0.06)
	background.size = Vector2(1152, 648)
	background.z_index = -10
	add_child(background)

	var banner_columns = [randi_range(2, 6), randi_range(8, 12), randi_range(14, 18)]

	for gx in range(-1, 21):
		for gy in range(-1, 11):
			var is_wall = gx == -1 or gx == 20 or gy == -1 or gy == 10
			var picture = ""
			if not is_wall:
				picture = "floor_%d" % randi_range(2, 8)
				if randf() < 0.65:
					picture = "floor_1"
			elif gx == -1:
				picture = "wall_left"
			elif gx == 20:
				picture = "wall_right"
			elif gy == -1 and banner_columns.has(gx):
				picture = ["wall_banner_red", "wall_banner_blue", "wall_banner_green"].pick_random()
			elif gy == -1 and randf() < 0.1:
				picture = ["wall_hole_1", "wall_goo"].pick_random()
			else:
				picture = "wall_mid"
			var tile = Game.make_sprite(Game.DT + picture + ".png", TILE)
			tile.position = ROOM.position + (Vector2(gx, gy) + Vector2(0.5, 0.5)) * TILE
			tile.z_index = -5
			tile.modulate = tint
			add_child(tile)

	shade(Rect2(ROOM.position, Vector2(ROOM.size.x, 26)), 0.45)
	shade(Rect2(ROOM.position, Vector2(14, ROOM.size.y)), 0.3)
	shade(Rect2(Vector2(ROOM.end.x - 14, ROOM.position.y), Vector2(14, ROOM.size.y)), 0.3)


func shade(area, darkness):
	var rect = ColorRect.new()
	rect.color = Color(0, 0, 0, darkness)
	rect.position = area.position
	rect.size = area.size
	rect.z_index = -4
	add_child(rect)


func scatter_decor():
	for i in 3:
		var skull = Game.make_sprite(Game.DT + "skull.png", 36)
		skull.position = Vector2(
			randf_range(ROOM.position.x + 40, ROOM.end.x - 40),
			randf_range(ROOM.position.y + 40, ROOM.end.y - 40))
		skull.z_index = -3
		add_child(skull)
