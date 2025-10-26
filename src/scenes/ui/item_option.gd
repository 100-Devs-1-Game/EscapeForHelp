class_name ItemOption
extends PanelContainer

@export var lbl_name: Label
@export var lbl_description: Label
@export var lbl_level: Label
@export var item_icon: TextureRect

var mouse_over: bool = false
var base_modulate: Color = Color.WHITE
var rarity_color: Color = Color.WHITE

signal option_selected(upgrade: String)

# Set background color tint for rarity
func set_rarity_background(color: Color) -> void:
	rarity_color = color
	# Apply a subtle tint to the panel
	base_modulate = Color(
		lerp(1.0, color.r, 0.15),
		lerp(1.0, color.g, 0.15),
		lerp(1.0, color.b, 0.15),
		1.0
	)
	modulate = base_modulate


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click") && mouse_over:
		option_selected.emit()


func _on_mouse_entered() -> void:
	mouse_over = true
	# Brighten on hover
	modulate = Color(
		lerp(1.0, rarity_color.r, 0.3),
		lerp(1.0, rarity_color.g, 0.3),
		lerp(1.0, rarity_color.b, 0.3),
		1.0
	)


func _on_mouse_exited() -> void:
	mouse_over = false
	# Return to base color
	modulate = base_modulate
