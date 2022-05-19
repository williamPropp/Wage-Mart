extends Node2D

var rng = RandomNumberGenerator.new()

onready var hand = get_node("hand")
onready var shopping_cart = get_node("shopping_cart")

onready var hand_open_sprite = load("res://assets/open_arm.png")
onready var hand_closed_sprite = load("res://assets/closed_arm.png")

var shopping_cart_speed = 6
var customer_hand_speed = 8
var cash_drawer_speed = 6
var shopping_cart_enter = false
var shopping_cart_exit = false

var opening_cash_box = false
var closing_cash_box = false
var extending_cash_hand = false
var withdrawing_cash_hand = false

var num_items
var shopper_cart_items = []

func _ready():
	rng.randomize()
	new_shopper()
#	get_tree().debug_collisions_hint = true

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
	if(shopping_cart_enter || shopping_cart_exit):
		shopping_cart.position.x -= shopping_cart_speed
		if(shopping_cart_enter && shopping_cart.position.x < 500):
			shopping_cart_enter = false
		elif(shopping_cart_exit && shopping_cart.position.x < -400):
			shopping_cart_exit = false
	
	if( !test_grocery_stop() ):
		Global.is_entry_conveyor_active = false
	else:
		Global.is_entry_conveyor_active = true
	
	if(opening_cash_box):
		if($register_drawer.position.y < 256):
			$register_drawer.position.y += cash_drawer_speed
		else:
			opening_cash_box = false
	elif(closing_cash_box):
		if($register_drawer.position.y >= 158):
			$register_drawer.position.y -= cash_drawer_speed
		else:
			closing_cash_box = false
			$register_drawer.position.y = 158
	
	if(extending_cash_hand):
		if($customer_hand.position.x > 650):
			$customer_hand.position += Vector2(-customer_hand_speed, customer_hand_speed)
		else:
			extending_cash_hand = false
	elif(withdrawing_cash_hand):
		if($customer_hand.position.y > -280):
			$customer_hand.position -= Vector2(-customer_hand_speed, customer_hand_speed)
		else:
			withdrawing_cash_hand = false
			$customer_hand.position = Vector2(1000, -300)
	
	if(num_items == 0):
		num_items -= 1
		$customer_hand/cash.visible = true
		extending_cash_hand = true
		$customer_hand.texture = hand_closed_sprite
		opening_cash_box = true

func spawn_rand_grocery_item():
	var new_grocery_item = load("res://prefabs/grocery_item.tscn").instance()
	var rand_y = rng.randi_range(180, 400)
	self.add_child(new_grocery_item)
	new_grocery_item.position = Vector2(2048, rand_y)
	var rand_grocery_type = Global.grocery_item_types[ rng.randi_range(0, 4) ]
	new_grocery_item.apply_texture(rand_grocery_type)
	new_grocery_item.grocery_type = rand_grocery_type

func new_shopper():
	shopping_cart.position.x = 1400
	shopping_cart_enter = true
	shopper_cart_items = []
	
	num_items = rng.randi_range(3, 7)
	var time_between_items = rng.randf_range(0.7, 2)
	for i in range(0,num_items):
		spawn_rand_grocery_item()
		yield(get_tree().create_timer(time_between_items), "timeout")

func groc_item_exited_left(groc_type):
	shopper_cart_items.append(groc_type)
	num_items -= 1

func test_grocery_stop():
	for groc_item in get_tree().get_nodes_in_group("grocery_items"):
		if(groc_item.is_within_conveyor_stop): return false
	return true

func cash_taken():
	withdrawing_cash_hand = true
	$customer_hand.texture = hand_open_sprite

func cash_deposited_in_cashbox():
	closing_cash_box = true
	yield(get_tree().create_timer(1.5), "timeout")
	shopping_cart_exit = true
	yield(get_tree().create_timer(4.0), "timeout")
	new_shopper()

func edit_saturation(value):
	var shader = get_node("greyscale_parent/greyscale").material
	shader.set_shader_param("weight", value)
