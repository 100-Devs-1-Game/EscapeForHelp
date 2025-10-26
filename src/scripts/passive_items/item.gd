class_name Item
extends Node

@export var current_level: int = 1
@export var max_level: int = 1

# Fusion recipes available for this item
var fusion_recipes: Array[ItemFusionRecipe] = []

func initialise(data: ItemData) -> void:
	max_level = data.max_level
	fusion_recipes = data.fusion_recipes

# Returns true if we can level up (i.e. current_level is below max_level)
func can_level_up() -> bool:
	return current_level < max_level

# When leveling up, process any automatic fusion recipes
func do_level_up() -> bool:
	ItemFusionManager.process_auto_fusions(self)
	return true

func on_equip() -> void:
	# Override in child classes to add equip effects.
	pass

func on_unequip() -> void:
	# Override in child classes to remove equip effects.
	pass
