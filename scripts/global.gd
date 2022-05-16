extends Node

var current_scene_state
enum Scene_States {main_menu_scene_state, scanning_scene_state, baggin_scene_state, finance_scene_state}

var hand
var hand_position

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	hand = get_tree().get_nodes_in_group("hand")[0]

func _physics_process(delta):
	hand_position = hand.position


