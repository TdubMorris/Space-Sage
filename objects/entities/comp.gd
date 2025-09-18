extends Racer
class_name CompOpponent

@export var speed : float = 500
@export var turn_speed : float = 1000
@export var rotation_curve : Curve

var target : Vector2

@onready var navigator = $NavigationAgent2D as NavigationAgent2D

var pathfollower = PathFollow2D

func _ready():
	pathfollower = PathFollow2D.new()
	get_tree().get_first_node_in_group("Path").add_child(pathfollower)


func _physics_process(_delta):
	target = navigator.get_next_path_position()
	thrust(speed)
	steer(turn_speed * rotation_curve.sample(get_angle_to(target)))
	

func _process(_delta):
	if global_position.distance_to(pathfollower.global_position) < 100:
		pathfollower.set_progress(pathfollower.progress + 5.0)

func _on_timer_timeout():
	navigator.target_position = pathfollower.global_position
	pass # Replace with function body.
