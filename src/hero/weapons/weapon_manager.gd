class_name WeaponManager
extends Node

const BULLET_SCENE: PackedScene = preload("uid://c6td74vi0i13n")
const BASE_DAMAGE: float = 5

signal fired()

@export var stats: PlayerStats
@export var raycast: RayCast3D
@export var fire_point: Node3D
@export var cooldown: Timer

func _physics_process(_delta: float) -> void:
	if not cooldown.is_stopped() or not raycast.is_colliding():
		return
	
	fire()

func fire() -> void:
	cooldown.start()
	fired.emit()
	
	var direction := raycast.target_position.normalized()
	make_bullet(direction, make_attack_data())

func make_bullet(direction: Vector3, data: AttackData) -> PlayerBullet:
	var instance = BULLET_SCENE.instantiate() as PlayerBullet
	get_tree().root.add_child(instance)
	instance.global_position = fire_point.global_position
	instance.setup(direction, data)
	return instance

func make_attack_data() -> AttackData:
	var data := AttackData.new()
	var is_critical_hit: bool = randf() <= stats.actual_stats.critical_chance
	data.damage = BASE_DAMAGE * stats.actual_stats.weapon_damage
	
	if is_critical_hit:
		data.damage *= stats.actual_stats.critical_power
	
	return data
