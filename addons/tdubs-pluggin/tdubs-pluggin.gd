@tool
extends EditorPlugin

const MainPanel = preload("res://addons/tdubs-pluggin/editor/main_screen.tscn")
var panel_instance

func _enable_plugin():
	# Add autoloads here.
	pass


func _disable_plugin():
	# Remove autoloads here.
	pass


func _enter_tree():
	panel_instance = MainPanel.instantiate()
	EditorInterface.get_editor_main_screen().add_child(panel_instance)
	_make_visible(false)


func _exit_tree():
	if panel_instance:
		panel_instance.queue_free()


func _has_main_screen():
	return true


func _make_visible(visible):
	if panel_instance:
		panel_instance.visible = visible


func _get_plugin_name():
	return "Notes"


func _get_plugin_icon():
	return EditorInterface.get_editor_theme().get_icon("Node", "EditorIcons")
