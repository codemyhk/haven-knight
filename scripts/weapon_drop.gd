extends Area2D

var weapon_id = "pistol"
var sprite = null
var label = Label.new()
var near = false
var time = 0.0


func _ready():
	var shape = CollisionShape2D.new()
	var circle = CircleShape2D.new()
	circle.radius = 34
	shape.shape = circle
	add_child(shape)

	sprite = Sprite2D.new()
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	add_child(sprite)

	label.position = Vector2(-70, -64)
	label.visible = false
	add_child(label)

	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	refresh()


func refresh():
	sprite.texture = load(Game.WEAPONS[weapon_id]["art"])
	Game.fit_sprite(sprite, 44)
	label.text = "[E] take " + weapon_id.to_upper()


func _process(delta):
	time += delta
	sprite.position.y = sin(time * 3.0) * 3.0
	label.visible = near
	if near and Input.is_action_just_pressed("interact"):
		var old = Game.weapon_id
		Game.weapon_id = weapon_id
		weapon_id = old
		Game.play_sound("click")
		refresh()


func _on_body_entered(body):
	if body.is_in_group("player"):
		near = true


func _on_body_exited(body):
	if body.is_in_group("player"):
		near = false
