extends Node2D

var rng = RandomNumberGenerator.new()

onready var hand = get_node("hand")

onready var hand_open_sprite = load("res://assets/open_arm.png")
onready var hand_closed_sprite = load("res://assets/closed_arm.png")

var held_grocery_item

func _ready():
	rng.randomize()

func _input(event):
	if(event is InputEventMouseMotion):
		if(event.position.x > 55 && event.position.x < 985):
			hand.position.x = event.position.x
		if(event.position.y > 200):
			hand.position.y = event.position.y
			
	if Input.is_action_just_pressed("left_mouse"):
		hand.texture = hand_closed_sprite
	elif Input.is_action_just_released("left_mouse"):
		hand.texture = hand_open_sprite
	
func spawn_customers_items():
	pass

func edit_saturation(value):
	var shader = get_node("greyscale_parent/greyscale").material
	shader.set_shader_param("weight", value)
