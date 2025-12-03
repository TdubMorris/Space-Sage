extends Control

func _on_button_pressed():
	get_tree().change_scene_to_file("res://objects/scenes/game_overlay.tscn")
