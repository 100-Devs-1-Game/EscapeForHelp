class_name Player
extends CharacterBody3D

@export var movement_speed: float = 4

# Movement tracking for weapons
var last_movement: Vector3 = Vector3.ZERO

# Touch movement value (-1 = left, 0 = none, 1 = right)
var touch_movement := 0.0

@export var player_stats: PlayerStats
@export var player_inventory: PlayerInventory

func _init() -> void:
	Global.player = self

func _ready() -> void:
	# Optional: debug print to confirm viewport size
	print("Screen width:", get_viewport().get_visible_rect().size.x)

func _input(event: InputEvent) -> void:
	# Detect touch or drag
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		var screen_half := get_viewport().get_visible_rect().size.x / 2
		
		if event.position.x < screen_half:
			touch_movement = -1.0       # Touch on left side
		else:
			touch_movement = 1.0        # Touch on right side

	# Stop when finger/mouse is released
	if event is InputEventScreenTouch and not event.pressed:
		touch_movement = 0.0

	# Debug print
	# print("Touch detected at:", event.position, "Touch movement:", touch_movement)

func _process(_delta: float) -> void:
	var horizontal_input: float = get_horizontal_movement()
	velocity = Vector3(horizontal_input, 0, -1)
	velocity *= movement_speed

	# Track last movement direction for combat or animation
	if velocity.length() > 0:
		last_movement = velocity.normalized()

	move_and_slide()

func get_horizontal_movement() -> float:
	# Keyboard input still works
	var direction := 0.0
	if Input.is_action_pressed("move_left"):
		direction = -1.0
	elif Input.is_action_pressed("move_right"):
		direction = 1.0

	# Touch input overrides keyboard if active
	if touch_movement != 0.0:
		return touch_movement

	return direction
