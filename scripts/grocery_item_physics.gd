extends RigidBody2D

var click_offset
var is_pickupable = false
var is_dragging = false
var is_within_bag = false

var pickup_grow_factor = 1.05


#func _ready():
#	self.set_sleeping(true)

func _input(event):
	if Input.is_action_just_pressed("left_mouse") && is_pickupable:
		is_dragging = true
		click_offset = global_position - event.position
		self.get_node("grocery_item_sprite").scale = Vector2(pickup_grow_factor, pickup_grow_factor)
		mode = MODE_STATIC
	elif Input.is_action_just_released("left_mouse") && is_dragging:
		self.get_node("grocery_item_sprite").scale = Vector2(1, 1)
		self.apply_impulse(Vector2(0,0), Vector2(0,1))
		self.set_sleeping(false)
		is_dragging = false
		mode = MODE_RIGID

func _physics_process(delta):
	if(is_dragging):
		self.global_position = Global.hand_position + click_offset

func _integrate_forces(state):
	if(is_dragging):
		state.set_linear_velocity(Vector2(0,0))
		state.set_angular_velocity(0)


func apply_texture(texture_name):
	if(Global.grocery_item_types.has(texture_name)):
		get_node("grocery_item_sprite").texture = load("res://assets/" + texture_name + ".png")
	else:
		print("texture_name not in Global.grocery_item_types")
	
	var new_scale = Vector2(1.0, 1.0)
	var new_position = Vector2(0.0, 0.0)
	match(texture_name):
		("apple"):
			new_scale = Vector2(0.7, 0.7)
			new_position = Vector2(5.0, 5.0)
		("bleach"):
			new_scale = Vector2(1.5, 2.7)
		("cheese"):
			new_scale = Vector2(1.0, 0.7)
			new_position = Vector2(1.0, 12.0)
		("chips"):
			new_scale = Vector2(1.5, 2.0)
		("soda"):
			new_scale = Vector2(0.7, 1.2)
		("cash"):
			new_position = Vector2(40.0, 40.0)
	
	self.get_node("groc_item_hbox/area2d's poly").scale = new_scale
	self.get_node("groc_item_hbox/area2d's poly").position += new_position
	self.get_node("groc_item_rigib_body_poly").scale = new_scale
	self.get_node("groc_item_rigib_body_poly").position += new_position
	
func _on_groc_item_hbox_area_entered(area):
	if(area.is_in_group("bag")): is_within_bag = true
	if(area.get_parent().is_in_group("hand") && !is_within_bag): is_pickupable = true
	

func _on_groc_item_hbox_area_exited(area):
	if(area.is_in_group("bag")): is_within_bag = false
	if(area.get_parent().is_in_group("hand")): is_pickupable = false
