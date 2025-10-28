class_name LocationPart
extends Node3D

@export var end_of_location: Node3D

func get_location_length() -> float:
	return abs(end_of_location.position.z)

func initialize() -> void:
	pass

func dispose() -> void:
	pass
