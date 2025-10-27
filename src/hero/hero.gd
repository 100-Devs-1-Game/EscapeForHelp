class_name Player
extends CharacterBody3D

@export var movement_speed: float = 4

# Movement tracking for weapons
var last_movement: Vector3 = Vector3.ZERO

#TODO: Check if I should keep this
@export var player_stats: PlayerStats
@export var player_inventory: PlayerInventory

func _init() -> void:
	Global.player = self

func _process(_delta: float) -> void:
	var horizontal_input: float = get_horizontal_movement()
	velocity.x = horizontal_input * movement_speed
	velocity.z = -movement_speed

	# Track last movement direction
	if velocity.length() > 0:
		last_movement = velocity.normalized()

	move_and_slide()

func get_horizontal_movement() -> float:
	var direction: float = 0.0
	if Input.is_action_pressed("move_left"):
		direction = -1.0
	elif Input.is_action_pressed("move_right"):
		direction = 1.0
	return direction
