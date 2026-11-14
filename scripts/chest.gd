extends Area2D

const DROP = preload("res://scenes/weapon_drop.tscn")

var opened = false
var sprite = null


func _ready():
	var shape = CollisionShape2D.new()
	var rect = RectangleShape2D.new()
	rect.size = Vector2(40, 40)
	shape.shape = rect
	add_child(shape)
	sprite = Game.make_sprite(Game.DT + "chest_full_open_anim_f0.png", 52)
	add_child(sprite)
	body_entered.connect(_on_body_entered)


func _on_body_entered(body):
	if opened or not body.is_in_group("player"):
		return
	opened = true
	Game.play_sound("chest")
	sprite.texture = load(Game.DT + "chest_full_open_anim_f2.png")

	var old_weapon = Game.weapon_id
	Game.weapon_id = Game.random_weapon()
	var drop = DROP.instantiate()
	drop.weapon_id = old_weapon
	drop.position = position + Vector2(0, 80)
	get_parent().add_child.call_deferred(drop)

	var label = Label.new()
	label.text = "You got: " + Game.weapon_id.to_upper() + "!"
	label.position = Vector2(-70, -60)
	add_child(label)
	await get_tree().create_timer(2.0).timeout
	label.queue_free()
