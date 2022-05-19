extends Node2D

var rng = RandomNumberGenerator.new()

onready var hand = get_node("hand")

onready var hand_open_sprite = load("res://assets/open_arm.png")
onready var hand_closed_sprite = load("res://assets/closed_arm.png")

var held_grocery_item
var item_distance = 100

func _ready():
	rng.randomize()
	spawn_customers_items()

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
	var index = 0
	for groc_item in Global.shopper_cart_items:
		var loaded_groc_item = load("res://prefabs/grocery_item_physics.tscn").instance()
		self.add_child(loaded_groc_item)
		loaded_groc_item.position = Vector2(300 + (item_distance * index), 500)
		loaded_groc_item.apply_texture(groc_item)
		index += 1

func edit_saturation(value):
	var shader = get_node("greyscale_parent/greyscale").material
	shader.set_shader_param("weight", value)
