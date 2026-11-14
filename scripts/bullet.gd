extends Area2D

var direction = Vector2.RIGHT
var speed = 600.0
var damage = 10.0
var pierce = 0
var hits = "enemies"
var art = ""
var style = "ball"
var life = 2.5


func _ready():
	var shape = CollisionShape2D.new()
	var circle = CircleShape2D.new()
	circle.radius = 6
	if art != "":
		circle.radius = 9
	shape.shape = circle
	add_child(shape)
	body_entered.connect(_on_body_entered)
	if art != "":
		var picture = Game.make_projectile(art)
		picture.rotation = direction.angle()
		add_child(picture)
	elif style == "arrow":
		var arrow = Sprite2D.new()
		arrow.texture = load(Game.ARROW)
		arrow.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		arrow.scale = Vector2(2.5, 2.5)
		arrow.rotation = direction.angle()
		add_child(arrow)


func _physics_process(delta):
	position += direction * speed * delta
	life -= delta
	if life <= 0.0:
		queue_free()


func _on_body_entered(body):
	if body.is_in_group(hits):
		body.take_damage(damage, direction * 12.0)
		if pierce <= 0:
			queue_free()
		else:
			pierce -= 1
	elif body.is_in_group("walls"):
		queue_free()


func _draw():
	if art != "":
		return
	if style == "ball":
		draw_circle(Vector2.ZERO, 7, Color.YELLOW.darkened(0.4))
		draw_circle(Vector2.ZERO, 5, Color.YELLOW)
	elif style == "tracer":
		var tail = -direction * 60.0
		draw_line(tail, Vector2.ZERO, Color(0.6, 0.9, 1.0, 0.5), 7)
		draw_line(tail, Vector2.ZERO, Color.WHITE, 3)
