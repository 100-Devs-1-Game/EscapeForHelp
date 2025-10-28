class_name ExperienceGem
extends Area3D

@export var experience : int = 1
@export var speed: float = -0.3
@export var pickup_speed_step: float = 4

@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var snd_collected: AudioStreamPlayer = $SndCollected

var target : Node3D = null

func _ready() -> void:
	# Create a new material to override the mesh color based on experience value
	var material: StandardMaterial3D = mesh_instance_3d.get_surface_override_material(0)
	
	if experience < 5:
		material.albedo_color = Color(0.2, 0.5, 1.0)
	elif experience < 25:
		material.albedo_color = Color(1.0, 0.9, 0.2)
	elif experience < 50:
		material.albedo_color = Color(1.0, 0.2, 0.2)
	else:
		material.albedo_color = Color(0.8, 0.2, 1.0)

func _physics_process(delta : float) -> void:
	if target != null:
		global_position = global_position.move_toward(target.global_position, speed)
		speed += pickup_speed_step * delta
		
func collect() -> int:
	snd_collected.play()
	collision_shape_3d.call_deferred("set", "disabled", true)
	mesh_instance_3d.visible = false
	return experience


func _on_snd_collected_finished() -> void:
	queue_free()
