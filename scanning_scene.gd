extends Node2D

var rng = RandomNumberGenerator.new()

onready var conveyor = get_node("conveyor_table")
onready var grocery = get_node("grocery_item")
onready var hand = get_node("hand")

onready var hand_open_sprite = load("res://assets/open_arm.png")
onready var hand_closed_sprite = load("res://assets/closed_arm.png")

var conveyor_speed = 1
#var conveyor_rect

var furthest_left_groc_item

func _ready():
	rng.randomize()
	new_shopper()
#	conveyor_rect = get_adjusted_rect(conveyor)

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

#func get_adjusted_rect(object):
#	var obj_rect = object.get_rect()
#	var obj_size = obj_rect.size
#	var obj_scale = object.scale
#	var obj_adjusted_size = obj_size * obj_scale
#	var obj_adjusted_pos = object.position
#	var adjusted_rect = Rect2(obj_adjusted_pos.x, obj_adjusted_pos.y, obj_adjusted_size.x, obj_adjusted_size.y)
#	return adjusted_rect

#func is_point_within_area(point, rect):
#	var rect_pos = rect.position
#	var rect_size = rect.size
#	var rect_top_bound = rect_pos.y
#	var rect_bottom_bound = rect_pos.y + rect_size.y
#	var rect_left_bound = rect_pos.x
#	var rect_right_bound = rect_pos.x + rect_size.x
#	return point.x > rect_left_bound && point.x < rect_right_bound && point.y > rect_top_bound && point.y < rect_bottom_bound

func spawn_rand_grocery_item():
	var new_grocery_item = load("res://prefabs/grocery_item.tscn").instance()
	var rand_y = rng.randi_range(180, 400)
	self.add_child(new_grocery_item)
	new_grocery_item.position = Vector2(1050, rand_y)
	new_grocery_item.apply_texture( Global.grocery_item_types[ rng.randi_range(0, 4) ] )
	print(new_grocery_item.position)
	print(new_grocery_item.z_index)

func new_shopper():
	var num_items = rng.randi_range(3, 7)
	var time_between_items = rng.randf_range(0.7, 2)
	for i in range(0,num_items):
		yield(get_tree().create_timer(time_between_items), "timeout")
		spawn_rand_grocery_item()
		

func edit_saturation(value):
	var shader = get_node("greyscale_parent/greyscale").material
	shader.set_shader_param("weight", value)
