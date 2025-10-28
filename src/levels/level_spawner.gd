class_name LevelSpawner
extends Node3D

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
	var distance := hero.global_position.z - next_part_position.z
	
	if distance < level_resource.spawn_distance:
		## IDK why, but it's fix bug with navigation areas
		## TODO: research this trouble
		await get_tree().process_frame
		create_next_part()
	
	if spawned_parts.size() > 0:
		var distance_from_previous := spawned_parts[0].position.z - hero.global_position.z
		if distance_from_previous > level_resource.spawn_distance:
			remove_first_part()

func create_next_part() -> void:
	var random_part: PackedScene = level_resource.locations.pick_random()
	var location: LocationPart = random_part.instantiate() as LocationPart
	parts.add_child(location)
	location.global_position = next_part_position
	next_part_position = location.end_of_location.global_position
	spawned_parts.push_back(location)

func remove_first_part() -> void:
	var part: LocationPart = spawned_parts.pop_front()
	
	if part:
		part.queue_free()
