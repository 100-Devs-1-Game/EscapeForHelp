class_name FloatingNumbersSpawner
extends Node

const FLOATING_LABEL_SCENE := preload("uid://3ep84ern8st5")

@export var center: Node3D
@export var radius: float

func spawn_attack_info(data: AttackData) -> void:
	var random_point := random_vector3()
	var random_position := center.global_position + random_point * radius
	var instance: Label3D = FLOATING_LABEL_SCENE.instantiate() as Label3D
	get_tree().root.add_child(instance)
	instance.global_position = random_position
	instance.text = str(int(data.damage))

static func random_vector3() -> Vector3:
	var theta := randf() * TAU
	var phi := acos(2.0 * randf() - 1.0)
	var sin_phi := sin(phi)
	return Vector3(cos(theta) * sin_phi, sin(theta) * sin_phi, cos(phi))
