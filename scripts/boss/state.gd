extends Node2D
class_name State
# from 16BitDev

var boss = null


func _ready():
	set_physics_process(false)


func enter():
	set_physics_process(true)


func exit():
	set_physics_process(false)


func transition():
	pass


func _physics_process(_delta):
	transition()
	boss.debug_label.text = name
