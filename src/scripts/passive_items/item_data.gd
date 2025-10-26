extends Resource
class_name ItemData

@export var icon: Texture2D
@export var max_level: int = 1

@export var fusion_recipes: Array[ItemFusionRecipe]

# Virtual method that subclasses must override
func get_level_data(_level: int) -> LevelData:
	push_warning("get_level_data is not implemented for this item!")
	return null
