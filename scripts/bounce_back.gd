extends CanvasLayer

const BAR_POS = Vector2(226, 330)
const BAR_SIZE = Vector2(700, 60)
const RED_WIDTH = 60.0
const SPEED = 450.0

var player = null
var arrow = Polygon2D.new()
var red = ColorRect.new()
var result = Label.new()
var red_width = RED_WIDTH
var arrow_x = 0.0
var direction = 1.0
var finished = false
var wait = 0.4


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true

	var dim = ColorRect.new()
	dim.color = Color(0, 0, 0, 0.65)
	dim.size = Vector2(1152, 648)
	add_child(dim)

	var title = Label.new()
	title.text = "do you want to BOUNCE BACK?"
	title.add_theme_font_size_override("font_size", 40)
	title.position = Vector2(250, 150)
	add_child(title)

	var hint = Label.new()
	hint.text = "click when the arrow is over the red square"
	hint.position = Vector2(380, 215)
	add_child(hint)

	var border = ColorRect.new()
	border.color = Color.WHITE
	border.position = BAR_POS - Vector2(4, 4)
	border.size = BAR_SIZE + Vector2(8, 8)
	add_child(border)

	var bar = ColorRect.new()
	bar.color = Color.BLACK
	bar.position = BAR_POS
	bar.size = BAR_SIZE
	add_child(bar)

	red_width = max(RED_WIDTH / pow(2.0, Game.bounces), 2.0)
	red.color = Color(0.9, 0.1, 0.1)
	red.size = Vector2(red_width, BAR_SIZE.y)
	red.position = Vector2(BAR_POS.x + randf_range(0.0, BAR_SIZE.x - red_width), BAR_POS.y)
	add_child(red)

	arrow.polygon = PackedVector2Array([Vector2(-16, -26), Vector2(16, -26), Vector2(0, 0)])
	arrow.color = Color.WHITE
	arrow.position = Vector2(BAR_POS.x, BAR_POS.y - 10)
	add_child(arrow)

	result.add_theme_font_size_override("font_size", 32)
	result.position = Vector2(420, 430)
	add_child(result)


func _process(delta):
	wait -= delta
	if finished:
		return
	arrow_x += direction * SPEED * delta
	if arrow_x > BAR_SIZE.x:
		arrow_x = BAR_SIZE.x
		direction = -1.0
	elif arrow_x < 0.0:
		arrow_x = 0.0
		direction = 1.0
	arrow.position.x = BAR_POS.x + arrow_x


func _input(event):
	if finished or wait > 0.0:
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		stop()


func stop():
	finished = true
	var red_left = red.position.x - BAR_POS.x
	var hit = arrow_x >= red_left and arrow_x <= red_left + red_width
	if hit:
		result.text = "BOUNCED BACK!"
		Game.play_sound("powerup")
	else:
		result.text = "too late..."
	await get_tree().create_timer(0.9).timeout
	if hit:
		get_tree().paused = false
		Game.bounces += 1
		player.revive()
		queue_free()
	else:
		Game.game_over()
