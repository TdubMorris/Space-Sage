extends Control

func _on_resume_button_button_up():
	hide()
	get_tree().paused = false


func _on_quit_button_button_up():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://objects/scenes/Menu/menu.tscn")
