extends Sprite

var rng = RandomNumberGenerator.new()

export var grocery_type : String
var click_offset
var is_dragging = false
var pickup_grow_factor = 1.05
var conveyor_speed = 2

var is_in_viewport = true
var is_pickupable = false
var on_entry_conveyor = false
var on_exit_conveyor = false

var cash_is_droppable = false

signal exited_left(groc_item_type)
signal cash_picked_up
signal cash_deposited

func _ready():
	rng.randomize()
	connect("exited_left", get_parent(), "groc_item_exited_left")
	connect("cash_picked_up", get_parent(), "cash_taken")
	connect("cash_deposited", get_parent(), "cash_deposited_in_cashbox")
	if(grocery_type):
		apply_texture(grocery_type)

func _input(event):
	if Input.is_action_just_pressed("left_mouse") && is_pickupable:
		# update click_offset and is_dragging state
		click_offset = position - event.position
		is_dragging = true
	elif Input.is_action_just_released("left_mouse"):
		scale = Vector2(1, 1)
		is_dragging = false

func _physics_process(delta):
	if(is_dragging):
		scale = Vector2(pickup_grow_factor, pickup_grow_factor)
		global_position = Global.hand_position + click_offset
		if(grocery_type == "cash"):
			emit_signal("cash_picked_up")
	elif(cash_is_droppable):
		self.position = Vector2(-88,-168)
		emit_signal("cash_deposited")
	
	if(on_entry_conveyor && !is_dragging && Global.is_entry_conveyor_active):
		if(position.x > 1024):
			self.position.x -= 5 * conveyor_speed
		elif(position.x > 460):
			self.position.x -= conveyor_speed
	
	if(on_exit_conveyor && !is_dragging):
		self.position.x -= conveyor_speed
	
	if(position.x < -120):
		emit_signal("exited_left", self.grocery_type)
		self.queue_free()

func _on_groc_item_hbox_area_entered(area):
	group_collision_update(area, true)

func _on_groc_item_hbox_area_exited(area):
	group_collision_update(area, false)

func group_collision_update(area, entered):
	if(area.get_parent().is_in_group("hand")):
		is_pickupable = entered
	elif(area.is_in_group("scanner") && grocery_type != "cash"):
		var beep_attempt = rng.randf_range(0,1)
		if(beep_attempt < 0.8 && entered):
			Global.play_sound("scanner_beep")
	elif(area.is_in_group("entry_conveyor")):
		on_entry_conveyor = entered
	elif(area.is_in_group("conveyor_stop")):
#		for groc_item in get_tree().get_nodes_in_group("grocery_items"):
#			groc_item.is_entry_conveyor_active = !entered
		Global.is_entry_conveyor_active = !entered
	elif(area.is_in_group("exit_conveyor")):
		on_exit_conveyor = entered
	elif(area.is_in_group("cashbox") && grocery_type == "cash"):
		cash_is_droppable = entered

func apply_texture(texture_name):
	if(Global.grocery_item_types.has(texture_name) || texture_name == "cash"):
		grocery_type = texture_name
		self.texture = load("res://assets/" + texture_name + ".png")
	else:
		print("texture_name not in Global.grocery_item_types or type 'cash'")

	if(texture_name == "bleach"):
		self.get_node("groc_item_hbox").scale = Vector2(1.5, 3.0)
	elif(texture_name == "chips"):
		self.get_node("groc_item_hbox").scale = Vector2(1.5, 2.0)
	elif(texture_name == "cash"):
		self.get_node("groc_item_hbox").position += Vector2(40.0, 40.0)
