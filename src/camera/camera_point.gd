class_name CameraPoint
extends Node3D

@export var follow_target: Node3D

func _process(_delta: float) -> void:
	position = follow_target.position
