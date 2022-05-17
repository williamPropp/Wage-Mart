extends Node2D

var rng = RandomNumberGenerator.new()

onready var conveyor = get_node("conveyor_table")
onready var grocery = get_node("grocery_item")
onready var hand = get_node("hand")

onready var hand_open_sprite = load("res://assets/open_arm.png")
onready var hand_closed_sprite = load("res://assets/closed_arm.png")

var conveyor_speed = 1

func _ready():
	rng.randomize()
	new_shopper()

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

func spawn_rand_grocery_item():
	var new_grocery_item = load("res://prefabs/grocery_item.tscn").instance()
	var rand_y = rng.randi_range(180, 400)
	self.add_child(new_grocery_item)
	new_grocery_item.position = Vector2(1650, rand_y)
	var rand_grocery_type = Global.grocery_item_types[ rng.randi_range(0, 4) ]
	new_grocery_item.apply_texture(rand_grocery_type)
	new_grocery_item.grocery_type = rand_grocery_type

func new_shopper():
#	var num_items = rng.randi_range(3, 7)
	var num_items = 7
	var time_between_items = rng.randf_range(0.7, 2)
	for i in range(0,num_items):
		spawn_rand_grocery_item()
		yield(get_tree().create_timer(time_between_items), "timeout")
		

func edit_saturation(value):
	var shader = get_node("greyscale_parent/greyscale").material
	shader.set_shader_param("weight", value)
