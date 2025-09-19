class_name Player
extends Racer


func _physics_process(_delta):
	if not (Input.is_action_pressed("Left") and Input.is_action_pressed("Right")):
		thrust(500)
		if Input.is_action_pressed("Left"):
			steer(-1500)
		elif Input.is_action_pressed("Right"):
			steer(1500)
