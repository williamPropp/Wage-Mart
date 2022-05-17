extends RigidBody2D

var translate_offset
var is_pickupable = false
var is_dragging = false

var pickup_grow_factor = 1.05


#func _ready():
#	self.set_sleeping(true)

func _input(event):
	if Input.is_action_just_pressed("left_mouse") && is_pickupable:
		is_dragging = true
		self.get_node("grocery_item_sprite").scale = Vector2(pickup_grow_factor, pickup_grow_factor)
		print("picked up")
	elif Input.is_action_just_released("left_mouse") && is_dragging:
		self.get_node("grocery_item_sprite").scale = Vector2(1, 1)
		self.apply_impulse(Vector2(0,0), Vector2(0,1))
		self.set_sleeping(false)
		is_dragging = false

func _physics_process(delta):
	if(is_dragging):
		self.global_position = Global.hand_position

func _integrate_forces(state):
	if(is_dragging):
		state.set_linear_velocity(Vector2(0,0))
		state.set_angular_velocity(0)


func apply_texture(texture_name):
	if(Global.grocery_item_types.has(texture_name)):
		get_node("grocery_item_sprite").texture = load("res://assets/" + texture_name + ".png")
	else:
		print("texture_name not in Global.grocery_item_types")

func _on_groc_item_hbox_area_entered(area):
	if(area.get_parent().is_in_group("hand")): is_pickupable = true


func _on_groc_item_hbox_area_exited(area):
	if(area.get_parent().is_in_group("hand")): is_pickupable = false
