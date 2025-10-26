class_name ItemContainer
extends TextureRect

var upgrade : Variant = null

func assign_item(item: Item) -> void:
	$ItemTexture.texture = item.data.icon

func clear_item() -> void:
	$ItemTexture.texture = null
