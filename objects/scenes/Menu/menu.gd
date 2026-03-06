extends Control

func _on_button_pressed():
	FileManager.load_from_resource("test")

func _on_editor_pressed():
	get_tree().call_deferred("change_scene_to_file","res://editor/editor.scn")
