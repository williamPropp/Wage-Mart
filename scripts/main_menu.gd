extends Control




func _on_play_btn_pressed():
	Global.scene_switch("scanning_scene")


func _on_quit_btn_pressed():
	get_tree().quit()
