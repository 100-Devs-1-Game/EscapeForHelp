class_name ProjectVersionLabel
extends Label

func _ready() -> void:
	text = ProjectVersion.get_line()
