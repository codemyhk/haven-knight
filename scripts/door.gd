extends Area2D

var used = false


func _ready():
	var shape = CollisionShape2D.new()
	var rect = RectangleShape2D.new()
	rect.size = Vector2(40, 40)
	shape.shape = rect
	add_child(shape)
	add_child(Game.make_sprite(Game.DT + "floor_ladder.png", 56))
	body_entered.connect(_on_body_entered)


func _on_body_entered(body):
	if body.is_in_group("player") and not used:
		used = true
		Game.go_next_floor.call_deferred()
