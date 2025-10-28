class_name Zombie
extends CharacterBody3D

@export var health: int = 10

func take_damage(attack: AttackData) -> void:
	health -= attack.damage
	
	if health <= 0:
		queue_free()
