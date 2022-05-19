extends Node

#enum Scene_State {main_menu_scene_state, scanning_scene_state, bagging_scene_state, finance_scene_state}
#var current_scene_state = Scene_State.main_menu_scene_state
var current_scene_name
var current_scene

var grocery_item_types = ["apple", "bleach", "cheese", "chips", "soda"]
var shopper_cart_items = []
var is_entry_conveyor_active = true

var hand
var hand_position


func _ready():
	get_tree().debug_collisions_hint = true
	shopper_cart_items = ["cheese", "bleach", "soda", "apple"]
	scene_switch("bagging_scene")

func _physics_process(delta):
	if(current_scene_name == "scanning_scene" || current_scene_name == "bagging_scene"):
		if(hand): hand_position = hand.position

func scene_switch(scene_name):
	var next_scene = load("res://scenes/" + scene_name + ".tscn").instance()
	self.add_child(next_scene)
	if(current_scene):
		current_scene.queue_free()
	current_scene = next_scene
	current_scene_name = scene_name
	
	match(scene_name):
		("main_menu"):
			pass
		("scanning_scene"):
			hand = get_node(scene_name + "/hand")
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		("bagging_scene"):
			hand = get_node(scene_name + "/hand")
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		("week_breakdown"):
			pass
	
func play_sound(sample_name, bus = "Master"):
	var sample_path
	match(sample_name):
		"scanner_beep":
			sample_path = "res://sounds/scanner_beep.mp3"
	
	var new_stream_player = AudioStreamPlayer.new()
	add_child(new_stream_player)
	
	# load the audio path
	var sound_to_play = load(sample_path)
	
	# create new stream player instance to host the sound, then play the sound
	new_stream_player.stream = sound_to_play
	new_stream_player.bus = bus
	new_stream_player.play(0.0)
	
	# delete node once the sample finishes playing
	yield(new_stream_player, "finished")
	new_stream_player.stop()
	new_stream_player.queue_free()

#knowledge for later
#func ease_in_ease_out(current_val, min_val, max_val):
#	var slope_and_offset = range_to_min_max(min_val, max_val, 0, 1)
#	var ranged_val = ( current_val * slope_and_offset[0] ) + slope_and_offset[1]
#	var converted_val = -(cos(PI * ranged_val) - 1) / 2
##	return converted_val
#	return (converted_val - slope_and_offset[1]) / slope_and_offset[0]
#
#func range_to_min_max(min_val : float, max_val : float, new_min_val : float, new_max_val : float):
#	var slope = (new_max_val - new_min_val) / (max_val - min_val)
#	var offset = new_max_val - (slope * max_val)
#	var array = [slope, offset]
#	return array
