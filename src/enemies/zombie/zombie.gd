class_name Zombie
extends CharacterBody3D

@export var health: float = 10

@onready var floating_numbers_spawner: FloatingNumbersSpawner = %FloatingNumbersSpawner

func take_damage(attack: AttackData) -> void:
	health -= attack.damage
	floating_numbers_spawner.spawn_attack_info(attack)
	if health <= 0:
		queue_free()
