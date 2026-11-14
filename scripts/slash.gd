extends Area2D

var damage = 10.0
var reach = 70.0
var spin = false
var life = 0.15
var hit_list = []


func _ready():
	var shape = CollisionShape2D.new()
	var circle = CircleShape2D.new()
	if spin:
		circle.radius = reach
	else:
		circle.radius = reach * 0.5
	shape.shape = circle
	add_child(shape)
	body_entered.connect(_on_body_entered)


func _physics_process(delta):
	life -= delta
	if life <= 0.0:
		queue_free()


func _on_body_entered(body):
	if body.is_in_group("enemies") and not hit_list.has(body):
		hit_list.append(body)
		var push = (body.global_position - global_position).normalized() * 18.0
		body.take_damage(damage, push)
