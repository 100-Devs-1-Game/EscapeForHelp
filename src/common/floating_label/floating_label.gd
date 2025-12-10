class_name FloatingLabel
extends Label3D

const gravity = -9.8
const initial_y = 6
const x_range = 3.0
var _velocity: Vector3

func _ready() -> void:
	var x = randf_range(-x_range, x_range)
	_velocity = Vector3(x, initial_y, 0)
	
	scale = Vector3.ONE * 0.5
	var tween := create_tween()
	tween.tween_property(self, "scale", Vector3.ONE, 0.25).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)

func _physics_process(delta: float) -> void:
	_velocity.y += gravity * delta
	position += _velocity * delta
	#position = position.move_toward(position + Vector3.UP, delta / 2)
