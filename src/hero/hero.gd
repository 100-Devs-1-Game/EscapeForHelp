class_name Player
extends CharacterBody3D

# -------------------
# MOVEMENT VARIABLES
# -------------------
@export var movement_speed: float = 4
var last_movement: Vector3 = Vector3.ZERO
var touch_movement := 0.0

# -------------------
# PLAYER SYSTEMS
# -------------------
@export var player_stats: PlayerStats
@export var player_inventory: PlayerInventory

# -------------------
# HEALTH SYSTEM
# -------------------
@export var max_health: int = 100
var current_health: int

var can_take_damage := true
@export var damage_cooldown := 1.0   # seconds between damage ticks


# -------------------
# INIT + READY
# -------------------
func _init() -> void:
	Global.player = self

func _ready() -> void:
	current_health = max_health
	print("Screen width:", get_viewport().get_visible_rect().size.x)


# -------------------
# INPUT HANDLING (TOUCH + KEYBOARD)
# -------------------
func _input(event: InputEvent) -> void:
	# Touch input
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		var screen_half := get_viewport().get_visible_rect().size.x / 2
		
		if event.position.x < screen_half:
			touch_movement = -1.0
		else:
			touch_movement = 1.0

	# Stop when released
	if event is InputEventScreenTouch and not event.pressed:
		touch_movement = 0.0


# -------------------
# MAIN MOVEMENT LOOP
# -------------------
func _process(_delta: float) -> void:
	var horizontal_input: float = get_horizontal_movement()

	velocity = Vector3(horizontal_input, 0, -1)
	velocity *= movement_speed

	if velocity.length() > 0:
		last_movement = velocity.normalized()

	move_and_slide()


func get_horizontal_movement() -> float:
	var direction := 0.0

	# Keyboard
	if Input.is_action_pressed("move_left"):
		direction = -1.0
	elif Input.is_action_pressed("move_right"):
		direction = 1.0

	# Touch override
	if touch_movement != 0.0:
		return touch_movement

	return direction


# -------------------
# DAMAGE + HEALTH SYSTEM
# -------------------
func take_damage(amount: int):
	if not can_take_damage:
		return
	
	current_health -= amount
	print("⚠ Player took", amount, "damage. Health:", current_health)

	can_take_damage = false

	# Cooldown before next damage
	await get_tree().create_timer(damage_cooldown).timeout
	can_take_damage = true

	if current_health <= 0:
		die()


func die():
	print("💀 Player has died.")
	queue_free()
