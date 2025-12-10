class_name FloatingLabel
extends Label3D

func _ready() -> void:
	scale = Vector3.ONE * 0.5
	var tween := create_tween()
	tween.tween_property(self, "scale", Vector3.ONE, 0.25).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)

func _physics_process(delta: float) -> void:
	position = position.move_toward(position + Vector3.UP, delta / 2)
