extends Control

@onready var pausemenu = %PauseMenu

# Called when the node enters the scene tree for the first time.
func _ready():
	pausemenu.hide()
	RaceManager.reset()
	RaceManager.raceEnd.connect(show_endscreen)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("Pause") and !get_tree().paused and !RaceManager.raceEnded:
		pausemenu.show()
		get_tree().paused = true
	pass

func show_endscreen():
	%EndScreen.show()
	%GameHud.queue_free()
	%MobileInterface.queue_free()
	
