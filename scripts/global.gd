extends Node

var current_scene_state
enum Scene_States {main_menu_scene_state, scanning_scene_state, baggin_scene_state, finance_scene_state}

var grocery_item_types = []

var hand
var hand_position

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	hand = get_tree().get_nodes_in_group("hand")[0]

func _physics_process(delta):
	hand_position = hand.position

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
