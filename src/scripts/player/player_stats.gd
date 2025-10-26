class_name PlayerStats
extends Node

var base_stats: CharacterDataStats
var actual_stats: CharacterDataStats

@export var character_data: CharacterData

var health: float

# Current Stats Properties
var current_health: float:
	get:
		return health
	set(value):
		health = clamp(value, 0, actual_stats.health)
		Global.game_screen.update_health(int(health), int(actual_stats.health))

		# Check for death
		if health <= 0:
			if Global.game_screen:
				Global.game_screen.show_death_screen(false)

@export var inventory: PlayerInventory
@export var collector: Area3D
@export var grabber: Area3D

func _ready() -> void:
	# Assign the variables
	base_stats = character_data.stats
	actual_stats = character_data.stats.duplicate()
	set_grabber_radius(actual_stats.pickup_radius)
	health = actual_stats.health
	
	Global.game_screen.init_health_bar(int(actual_stats.health))
	Global.game_screen.update_stats_display(actual_stats)

func _process(delta: float) -> void:
	recover(delta)

func recalculate_stats() -> void:
	# Shallow copy is OK - CharacterDataStats contains only primitive types (floats)
	actual_stats = base_stats.duplicate()
	for slot: InventorySlot in inventory.passive_slots:
		var passive: Passive = slot.item as Passive
		if passive:
			actual_stats = actual_stats.add(passive.get_boosts())

	# Update the Grabber's radius (attracts gems from distance)
	set_grabber_radius(actual_stats.pickup_radius)

	# Update stats display
	Global.game_screen.update_stats_display(actual_stats)

func take_damage(damage: float) -> void:
	# Roll for dodge
	if randf() < actual_stats.dodge:
		return  # Dodged the attack

	damage -= actual_stats.defence

	if damage > 0:
		# Deal the damage
		current_health -= damage

func restore_health(amount: float) -> void:
	# Only heal the player if their current health is less than their maximum health
	if current_health < actual_stats.health:
		current_health += amount

		# Make sure the player's health doesn't exceed their maximum health
		if current_health > actual_stats.health:
			current_health = actual_stats.health

func recover(delta: float) -> void:
	if current_health < actual_stats.health:
		current_health += actual_stats.regeneration * delta

		# Make sure the player's health doesn't exceed their maximum health
		if current_health > actual_stats.health:
			current_health = actual_stats.health

func _on_hurt_box_hurt(damage: float, _angle: Vector3, _knockback: float) -> void:
	take_damage(damage)

func set_grabber_radius(radius: float) -> void:
	if grabber and grabber.get_child(0) is CollisionShape3D:
		var collision_shape: CollisionShape3D = grabber.get_child(0) as CollisionShape3D
		if collision_shape.shape is SphereShape3D:
			collision_shape.shape.radius = radius
