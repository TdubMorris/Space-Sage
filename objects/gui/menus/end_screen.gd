extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	RaceManager.raceEnd.connect(init_endscreen)

func init_endscreen():
	%TimeLabel.text = RaceManager.getTimeLabel()

func _on_quit_pressed():
	get_tree().change_scene_to_file("res://objects/scenes/Menu/menu.tscn")

func _on_retry_pressed():
	FileManager.load_level(RaceManager.current_id)
