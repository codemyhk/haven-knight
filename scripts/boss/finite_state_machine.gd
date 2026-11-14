extends Node2D
# from 16BitDev

var current_state: State
var previous_state: State


func _ready():
	current_state = get_child(0) as State
	previous_state = current_state
	current_state.enter()


func change_state(state_name):
	current_state = get_node(state_name) as State
	current_state.enter()

	previous_state.exit()
	previous_state = current_state
