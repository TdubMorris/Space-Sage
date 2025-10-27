extends Control

@onready var pausemenu = %PauseMenu

# Called when the node enters the scene tree for the first time.
func _ready():
	pausemenu.hide()
	TimeManager.reset()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause") and !get_tree().paused:
		pausemenu.show()
		get_tree().paused = true
	pass
