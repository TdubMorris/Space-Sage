@tool
class_name Player
extends Racer

@onready var bullet_scene = preload("res://objects/entities/bullet.tscn")
@onready var barrel = $BulletSpawn
@onready var cooldownTimer = $Cooldown
@onready var particles = $CPUParticles2D

@export var color : Color = Color(1, 1, 0, 1):
	set(value):
		color = value
		modulate = value

# Bullet cooldown
@export var cooldown : float = 0.25

#for detection if the player just started boosting
var is_coasting : bool = false


func _ready():
	cooldownTimer.wait_time = cooldown
	RaceManager.raceEnd.connect(race_end)

func _physics_process(delta):
	if Engine.is_editor_hint():
		return
	
	if RaceManager.raceEnded:
		linear_damp = 1.5
		return
	
	if not (Input.is_action_pressed("Left") and Input.is_action_pressed("Right")):
		if is_coasting and RaceManager.boost_charge >= RaceManager.boost_charge_time:
			apply_impulse(300*Vector2.RIGHT.rotated(rotation))
			var color_tween = get_tree().create_tween()
			modulate = Color(1,1,1,1)
			color_tween.tween_property(self, "modulate", color, 1.0)
		RaceManager.boost_charge = 0
		is_coasting = false
		particles.emitting = true
		
		thrust(500)
		linear_damp = 1.5
		if Input.is_action_pressed("Left"):
			steer(-1500)
		elif Input.is_action_pressed("Right"):
			steer(1500)
		if Input.is_action_pressed("Shoot"):
			spawn_bullet()
	else:
		is_coasting = true
		linear_damp = 0
		particles.emitting=false
		RaceManager.boost_charge = min(RaceManager.boost_charge + delta, RaceManager.boost_charge_time)

func spawn_bullet():
	if not cooldownTimer.is_stopped():
		return
	cooldownTimer.start()
	var bullet = bullet_scene.instantiate() as Bullet
	bullet.global_transform = barrel.global_transform
	bullet.velocity = linear_velocity + Vector2(300, 0).rotated(rotation)
	bullet.modulate = modulate
	bullet.shooter = self
	get_parent().add_child(bullet)

func race_end():
	particles.emitting = false
