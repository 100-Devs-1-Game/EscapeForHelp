class_name LevelSpawner
extends Node3D

const DISTANCE_BEFORE_REMOVE: float = 10

@export var hero: Node3D
@export var level_resource: LevelResource
@export var spawned_parts: Array[LocationPart]

@onready var parts: Node3D = %Parts

var next_part_position: Vector3

func _ready() -> void:
	for child in get_children():
		if child is LocationPart:
			spawned_parts.append(child)
	
	if spawned_parts.size() > 0:
		next_part_position = spawned_parts.back().end_of_location.global_position

func _physics_process(_delta: float) -> void:
	try_create_next_part()
	try_remove_oldest_part()

func try_create_next_part() -> void:
	var distance := hero.global_position.z - next_part_position.z
	
	if distance < level_resource.spawn_distance:
		create_next_part()

func try_remove_oldest_part() -> void:
	if spawned_parts.size() < 1:
		return
	
	var older_location := spawned_parts[0]
	var distance_from_previous := older_location.position.z - hero.global_position.z
	var remove_distance := older_location.get_location_length() + DISTANCE_BEFORE_REMOVE
	
	if distance_from_previous > remove_distance:
		remove_oldest_part()

func create_next_part() -> void:
	## IDK why, but this await fix bug with
	## baking navigation areas
	## TODO: research this trouble
	await get_tree().process_frame
	create_random_location()

func create_random_location() -> LocationPart:
	var random_part: PackedScene = level_resource.locations.pick_random()
	var location: LocationPart = random_part.instantiate() as LocationPart
	parts.add_child(location)
	location.global_position = next_part_position
	location.initialize()
	next_part_position = location.end_of_location.global_position
	spawned_parts.push_back(location)
	return location

func remove_oldest_part() -> void:
	var part: LocationPart = spawned_parts.pop_front()
	
	if part:
		part.dispose()
		part.queue_free()
