extends Sprite

var rng = RandomNumberGenerator.new()

export var grocery_type : String
var click_offset
var is_dragging = false
var pickup_grow_factor = 1.05
var conveyor_speed = 2

var is_entry_conveyor_active = false
var is_pickupable = false
var on_entry_conveyor = false
var on_exit_conveyor = false

func _ready():
	rng.randomize()

func _input(event):
	# tests whether a click occured within the area of the sprite
#	if Input.is_action_just_pressed("left_mouse") && get_rect().has_point(to_local(event.position)):
#		# update click_offset and is_dragging state
#		click_offset = position - event.position
#		is_dragging = true
#	elif Input.is_action_just_released("left_mouse"):
#		scale = Vector2(1, 1)
#		is_dragging = false
	if Input.is_action_just_pressed("left_mouse") && is_pickupable:
		# update click_offset and is_dragging state
		click_offset = position - event.position
		is_dragging = true
	elif Input.is_action_just_released("left_mouse"):
		scale = Vector2(1, 1)
		is_dragging = false

	if(is_dragging):
		scale = Vector2(pickup_grow_factor, pickup_grow_factor)
#		position = hand_node.position + click_offset
		position = Global.hand_position + click_offset

func _physics_process(delta):
	if(on_entry_conveyor && !is_dragging && is_entry_conveyor_active && position.x > 460):
		self.position.x -= conveyor_speed
	if(on_exit_conveyor && !is_dragging):
		self.position.x -= conveyor_speed

func _on_groc_item_hbox_area_entered(area):
	group_collision_update(area, true)

func _on_groc_item_hbox_area_exited(area):
	group_collision_update(area, false)

func group_collision_update(area, toggle_on):
	if(area.get_parent().is_in_group("hand")):
		is_pickupable = toggle_on
	elif(area.is_in_group("scanner")):
		var rand = rng.randi_range(0,5)
		if(rand > 4):
			print("scanned")
	elif(area.is_in_group("entry_conveyor")):
		on_entry_conveyor = toggle_on
	elif(area.is_in_group("conveyor_stop")):
		for groc_item in get_tree().get_nodes_in_group("grocery_items"):
			groc_item.is_entry_conveyor_active = !toggle_on
	elif(area.is_in_group("exit_conveyor")):
		on_exit_conveyor = toggle_on
