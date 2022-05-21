extends Node2D

onready var hand = get_node("hand")

onready var hand_open_sprite = load("res://assets/open_arm.png")
onready var hand_closed_sprite = load("res://assets/closed_arm.png")

var held_grocery_item
var item_spacing = 10

func _ready():
	hand.position = get_global_mouse_position()
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
		
func _physics_process(delta):
	items_in_bag_test()

func spawn_customers_items():
	var index = 0
	var x_pos = 730
	for groc_item in Global.shopper_cart_items:
		var loaded_groc_item = load("res://prefabs/grocery_item_physics.tscn").instance()
		self.add_child(loaded_groc_item)
		loaded_groc_item.apply_texture(groc_item)
		var item_width = loaded_groc_item.get_node("grocery_item_sprite").texture.get_width()
		x_pos -= (item_width/2) + item_spacing
		loaded_groc_item.position = Vector2(x_pos, 500)
		x_pos -= (item_width/2)
		index += 1	

func items_in_bag_test():
	var all_within_bag = true
	for groc_item in get_tree().get_nodes_in_group("grocery_items_physics"):
		if(!groc_item.is_within_bag):
			return
	return_to_scanning_scene()

func return_to_scanning_scene():
	yield(get_tree().create_timer(1.5), "timeout")
	Global.scene_switch("scanning_scene")

func edit_saturation(value):
	var shader = get_node("greyscale_parent/greyscale").material
	shader.set_shader_param("weight", value)
