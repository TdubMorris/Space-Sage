class_name Player
extends Racer

@onready var bullet_scene = preload("res://objects/entities/bullet.tscn")
@onready var barrel = $BulletSpawn

func _physics_process(_delta):
	if not (Input.is_action_pressed("Left") and Input.is_action_pressed("Right")):
		thrust(500)
		if Input.is_action_pressed("Left"):
			steer(-1500)
		elif Input.is_action_pressed("Right"):
			steer(1500)
		if Input.is_action_just_pressed("Shoot"):
			spawn_bullet()

func spawn_bullet():
	var bullet = bullet_scene.instantiate() as Bullet
	bullet.global_transform = barrel.global_transform
	bullet.velocity = linear_velocity + Vector2(300, 0).rotated(rotation)
	bullet.modulate = modulate
	bullet.shooter = self
	get_parent().add_child(bullet)
