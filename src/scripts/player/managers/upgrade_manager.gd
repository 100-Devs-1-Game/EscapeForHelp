class_name UpgradeManager
extends Node

enum Rarity { COMMON, RARE, EPIC }

signal upgrade_selected

var upgrade_options: Array[ItemOption] = []

var item_options: PackedScene = preload("uid://co84ocwm1cr62")

@export var food_resource: ItemData

# Base probabilities for rarity rolls
const BASE_COMMON_CHANCE: float = 0.70
const BASE_RARE_CHANCE: float = 0.25
const BASE_EPIC_CHANCE: float = 0.05
const MIN_COMMON_CHANCE: float = 0.30  # Never below 30% common

# Roll rarity based on player's luck stat
func roll_rarity(luck: float) -> Rarity:
	# Scale rare/epic chances with luck
	var scaled_epic: float = BASE_EPIC_CHANCE * luck
	var scaled_rare: float = BASE_RARE_CHANCE * luck
	var scaled_common: float = 1.0 - scaled_epic - scaled_rare

	# Ensure common never goes below minimum
	scaled_common = max(MIN_COMMON_CHANCE, scaled_common)

	# Normalize to 100%
	var total: float = scaled_common + scaled_rare + scaled_epic
	scaled_common /= total
	scaled_rare /= total
	scaled_epic /= total

	# Roll random
	var roll: float = randf()
	if roll < scaled_epic:
		return Rarity.EPIC
	elif roll < scaled_epic + scaled_rare:
		return Rarity.RARE
	else:
		return Rarity.COMMON

# Get number of levels to add based on rarity
func get_levels_for_rarity(rarity: Rarity) -> int:
	match rarity:
		Rarity.RARE:
			return 2
		Rarity.EPIC:
			return 3
		_:
			return 1

# Get color for rarity
func get_rarity_color(rarity: Rarity) -> Color:
	match rarity:
		Rarity.RARE:
			return Color(0.3, 0.6, 1.0)  # Blue
		Rarity.EPIC:
			return Color(0.6, 0.2, 1.0)  # Purple
		_:
			return Color.WHITE  # Common

# Get rarity display text
func get_rarity_text(rarity: Rarity, levels: int) -> String:
	match rarity:
		Rarity.RARE:
			return "LV: +%d ⭐⭐" % levels
		Rarity.EPIC:
			return "LV: +%d ⭐⭐⭐" % levels
		_:
			return "LV: +%d ⭐" % levels

func set_upgrades(inventory: PlayerInventory, possible_upgrades: Array[ItemData]) -> void:
	var options_max: int = 3

	# Clear old options from scene tree and free them
	for option in upgrade_options:
		if option.get_parent():
			option.get_parent().remove_child(option)
		option.queue_free()
	upgrade_options.clear()

	# Create new options
	for i: int in range(options_max):
		var option_choice: ItemOption = item_options.instantiate()
		upgrade_options.append(option_choice)

	var total_possible_upgrades: Array[ItemData] = possible_upgrades.duplicate()

	# Get player's luck stat for rarity rolls
	var luck: float = Global.player.player_stats.actual_stats.luck

	for option: ItemOption in upgrade_options:

		var selected: ItemData

		if total_possible_upgrades.size() > 0:
			selected = total_possible_upgrades.pick_random() as ItemData
			total_possible_upgrades.erase(selected)
		else:
			selected = food_resource

		# Roll rarity based on luck (but food is always COMMON)
		var rarity: Rarity = Rarity.COMMON if selected == food_resource else roll_rarity(luck)
		var levels_to_add: int = get_levels_for_rarity(rarity)

		var item: Item = inventory.get_item(selected)

		# Calculate actual levels that can be added (cap at max level)
		var actual_levels: int = levels_to_add
		if item:
			var remaining_levels: int = item.max_level - item.current_level
			actual_levels = min(levels_to_add, remaining_levels)

			# Downgrade rarity if we can't use all levels (prevents "wasted" rare drops)
			if actual_levels < levels_to_add:
				if actual_levels >= 3:
					rarity = Rarity.EPIC
				elif actual_levels >= 2:
					rarity = Rarity.RARE
				else:
					rarity = Rarity.COMMON
				levels_to_add = actual_levels

		if item:
			var level_data := selected.get_level_data(item.current_level + actual_levels)
			if not level_data:
				push_error("No level data for %s at level %d" % [selected, item.current_level + actual_levels])
				continue  # Skip this upgrade option

			option.lbl_name.text = level_data.name
			option.lbl_description.text = level_data.description
			if item.current_level >= item.max_level:
				# NOTE: Technically, it should never go here.
				option.lbl_level.text = "Max!"
				option.lbl_level.add_theme_color_override("font_color", Color.ORANGE_RED)
			else:
				# Show rarity with actual levels
				option.lbl_level.text = get_rarity_text(rarity, actual_levels)
				option.lbl_level.add_theme_color_override("font_color", get_rarity_color(rarity))
		else:
			var level_data := selected.get_level_data(actual_levels)
			if not level_data:
				push_error("No level data for %s at level %d" % [selected, actual_levels])
				continue  # Skip this upgrade option

			option.lbl_name.text = level_data.name
			option.lbl_description.text = level_data.description
			# For new items, show "New!" with rarity indicator
			option.lbl_level.text = "New! " + get_rarity_text(rarity, actual_levels)
			option.lbl_level.add_theme_color_override("font_color", get_rarity_color(rarity))

		option.item_icon.texture = selected.icon

		# Apply rarity background color
		option.set_rarity_background(get_rarity_color(rarity))

		# Connect a new lambda after disconnecting the old one
		for connection: Dictionary in option.option_selected.get_connections():
			option.option_selected.disconnect(connection.callable)

		# Capture rarity and actual_levels for the callback
		var captured_actual_levels: int = actual_levels
		option.option_selected.connect(func() -> void:
			if item:
				# Apply multiple level-ups based on rarity (capped at max level)
				for i: int in range(captured_actual_levels):
					if item.can_level_up():
						inventory.level_up_item(item)
					else:
						break  # Stop if max level reached
			else:
				# For new items, add the item first
				var slot_index: int = inventory.add_item(selected)
				if slot_index >= 0:
					# Then level it up additional times for rare/epic
					var added_item: Item = inventory.get_item(selected)
					if added_item:
						for i: int in range(captured_actual_levels - 1):
							if added_item.can_level_up():
								inventory.level_up_item(added_item)
							else:
								break
			upgrade_selected.emit()
		)

		Global.game_screen.upgrade_options_container.add_child(option)
