class_name Hero
extends CharacterBody3D

@export var movement_speed: float = 10

func _process(_delta: float) -> void:
	velocity.x = get_horizontal_movement()
	move_and_slide()

func get_horizontal_movement() -> float:
	if Input.is_action_pressed("move_left"):
		return -1
	elif Input.is_action_pressed("move_right"):
		return 1
	return 0
