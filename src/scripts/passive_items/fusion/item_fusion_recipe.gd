class_name ItemFusionRecipe
extends Resource

enum TriggerType { ON_LEVELUP, ON_PICKUP }
enum IngredientMode { CONSUME_ITEMS = 1, MERGE_ITEMS = 2 }

@export var recipe_name: String
@export var trigger: TriggerType = TriggerType.ON_LEVELUP
@export var ingredient_handling: IngredientMode = IngredientMode.CONSUME_ITEMS
@export var min_item_level: int = 1
@export var required_ingredients: Array[FusionIngredient]
@export var result_item: FusionIngredient
