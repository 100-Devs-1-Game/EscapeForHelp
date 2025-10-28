class_name PlayerBullet
extends Area3D

@export var speed: float = 20

var direction: Vector3
var attack: AttackData

func setup(movement_direction: Vector3, data: AttackData) -> void:
	direction = movement_direction
	attack = data

func _physics_process(delta: float) -> void:
	var movement_step := speed * delta
	position += direction * movement_step

func _on_body_entered(body: Zombie) -> void:
	body.take_damage(attack)
	queue_free()
