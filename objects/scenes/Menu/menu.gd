extends Control

func _on_button_pressed():
	FileManager.load_level("debug_level")

func _on_editor_pressed():
	get_tree().change_scene_to_file("res://editor/editor.tscn")
