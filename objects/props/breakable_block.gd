extends StaticBody2D

@warning_ignore("integer_division")

@export var maxHealth : int = 1

@onready var health : int = maxHealth
@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D

func hit():
	health -= 1
	sprite.frame = round((1.0 - float(health)/maxHealth) * 7);
	if(health <= 0):
		destroy()
	pass

func destroy():
	collision.set_deferred("disabled", true)
	sprite.frame = 8
	await get_tree().create_timer(5).timeout
	collision.set_deferred("disabled", false)
	sprite.frame = 0
	health = maxHealth
