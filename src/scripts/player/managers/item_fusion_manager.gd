class_name ItemFusionManager
extends Node

# Singleton instance
static var instance: ItemFusionManager

func _ready() -> void:
	instance = self

# Check if any fusions can be performed for the given item
static func check_fusion_eligibility(item: Item) -> Array[ItemFusionRecipe]:
	var eligible_recipes: Array[ItemFusionRecipe] = []

	if not item or not item.fusion_recipes:
		return eligible_recipes

	for recipe: ItemFusionRecipe in item.fusion_recipes:
		if validate_recipe(recipe, item):
			eligible_recipes.append(recipe)

	return eligible_recipes

# Validate if a recipe can be executed
static func validate_recipe(recipe: ItemFusionRecipe, source_item: Item) -> bool:
	if not _check_level_requirement(recipe, source_item):
		return false

	if not _check_ingredients_available(recipe):
		return false

	if not _check_ingredient_levels(recipe):
		return false

	return true

# Execute a fusion recipe
static func execute_fusion(recipe: ItemFusionRecipe, inventory: PlayerInventory, source_item: Item = null) -> bool:
	if not validate_recipe(recipe, source_item):
		return false

	var should_consume_passives: bool = recipe.ingredient_handling == ItemFusionRecipe.IngredientMode.CONSUME_ITEMS

	# Remove ingredient items if recipe requires consumption
	for ingredient: FusionIngredient in recipe.required_ingredients:
		if ingredient.required_item is PassiveData and should_consume_passives:
			inventory.remove_item(ingredient.required_item, true)

	# Remove source item if it should be consumed
	if source_item and source_item is Passive and should_consume_passives:
		inventory.remove_item((source_item as Passive).data, true)

	# Add the result item
	inventory.add_item(recipe.result_item.required_item)
	return true

# Process automatic fusions triggered by level up
static func process_auto_fusions(item: Item) -> void:
	if not item or not item.fusion_recipes:
		return

	for recipe: ItemFusionRecipe in item.fusion_recipes:
		if recipe.trigger == ItemFusionRecipe.TriggerType.ON_LEVELUP:
			execute_fusion(recipe, Global.player.player_inventory, item)

# Private validation helpers
static func _check_level_requirement(recipe: ItemFusionRecipe, source_item: Item) -> bool:
	if not source_item:
		return false

	if recipe.min_item_level > source_item.current_level:
		return false

	return true

static func _check_ingredients_available(recipe: ItemFusionRecipe) -> bool:
	if not Global.player or not Global.player.player_inventory:
		return false

	for ingredient: FusionIngredient in recipe.required_ingredients:
		var item: Item = Global.player.player_inventory.get_item(ingredient.required_item)
		if not item:
			return false

	return true

static func _check_ingredient_levels(recipe: ItemFusionRecipe) -> bool:
	if not Global.player or not Global.player.player_inventory:
		return false

	for ingredient: FusionIngredient in recipe.required_ingredients:
		var item: Item = Global.player.player_inventory.get_item(ingredient.required_item)
		if not item or item.current_level < ingredient.minimum_level:
			return false

	return true
