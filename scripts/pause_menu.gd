extends Control

var is_paused = false setget set_is_paused

func _input(event):
	if Input.is_action_just_pressed("pause"):
		self.is_paused = !is_paused
#		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func set_is_paused(new_is_paused_value):
	is_paused = new_is_paused_value
	get_tree().paused = is_paused
	visible = is_paused
	if(is_paused): 
		print("pause")
	else: 
		print("unpause")


func _on_quit_btn_pressed():
	get_tree().quit()

func _on_resume_btn_pressed():
	self.is_paused = false
