extends Sprite

export var grocery_type : String
var click_offset
var is_dragging = false
var pickup_grow_factor = 1.05

var is_pickupable = false

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


func _on_groc_item_hbox_area_entered(area):
#	print(area)
	pass

func _on_groc_item_hbox_area_exited(area):
#	print("exited " + str(area))
	pass
