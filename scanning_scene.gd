extends Node2D

var rng = RandomNumberGenerator.new()


var grocery_item_types = []
var grocery_items = []

onready var conveyor = get_node("conveyor_table")
onready var grocery = get_node("grocery_item")
onready var hand = get_node("hand")

onready var hand_open_sprite = load("res://assets/open_arm.png")
onready var hand_closed_sprite = load("res://assets/closed_arm.png")

var conveyor_speed = 1
var conveyor_rect

func _ready():
	rng.randomize()
	new_shopper()
	conveyor_rect = get_adjusted_rect(conveyor)
	spawn_grocery_item()

func _physics_process(delta):
	for i in grocery_items:
		if(i == null):
			pass
		elif(is_point_within_area(i.position, conveyor_rect)):
			i.position.x -= conveyor_speed

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

func get_adjusted_rect(object):
	var obj_rect = object.get_rect()
	var obj_size = obj_rect.size
	var obj_scale = object.scale
	var obj_adjusted_size = obj_size * obj_scale
	var obj_adjusted_pos = object.position
	var adjusted_rect = Rect2(obj_adjusted_pos.x, obj_adjusted_pos.y, obj_adjusted_size.x, obj_adjusted_size.y)
	return adjusted_rect

func is_point_within_area(point, rect):
	var rect_pos = rect.position
	var rect_size = rect.size
	var rect_top_bound = rect_pos.y
	var rect_bottom_bound = rect_pos.y + rect_size.y
	var rect_left_bound = rect_pos.x
	var rect_right_bound = rect_pos.x + rect_size.x
	return point.x > rect_left_bound && point.x < rect_right_bound && point.y > rect_top_bound && point.y < rect_bottom_bound

func spawn_grocery_item():
	var new_grocery_item = load("res://prefabs/grocery_item.tscn").instance()
	grocery_items.append(new_grocery_item)
	var new_grocery_item_height = new_grocery_item.get_rect().size.y
	var conveyor_top = conveyor_rect.position.y + (new_grocery_item_height / 1.5)
	var conveyor_bottom = conveyor_rect.position.y + conveyor_rect.size.y - (new_grocery_item_height / 1.5)
	var rand_y = rng.randi_range(conveyor_top, conveyor_bottom)
	self.add_child(new_grocery_item)
	new_grocery_item.position = Vector2(conveyor_rect.position.x + conveyor_rect.size.x, rand_y)

func new_shopper():
	var num_items = rng.randi_range(3, 7)
	var time_between_items = rng.randf_range(0.2, 0.8)
	for i in range(0,num_items):
		yield(get_tree().create_timer(time_between_items), "timeout")
		spawn_grocery_item()
		

func edit_saturation(value):
	var shader = get_node("greyscale_parent/greyscale").material
	shader.set_shader_param("weight", value)
