class_name LifeTimer
extends Timer

@export var target_for_destroy: Node

func _ready() -> void:
	timeout.connect(_on_timeout)

func _on_timeout() -> void:
	target_for_destroy.queue_free()
