extends Control

func _on_button_pressed():
	var level = preload("res://objects/scenes/debug_level.scn").instantiate()
	var game_screen = preload("res://objects/scenes/gamescreen.tscn").instantiate()
	game_screen.add_child(level)
	get_tree().change_scene_to_node(game_screen)

func _on_editor_pressed():
	get_tree().change_scene_to_file("res://editor/editor.tscn")
