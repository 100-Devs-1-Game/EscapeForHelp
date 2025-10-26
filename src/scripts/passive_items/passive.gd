class_name Passive
extends Item

var data: PassiveData
var current_boosts: CharacterDataStats = CharacterDataStats.new()

# IMPORTANT: The function signature must match the parent.
# So we accept an ItemData and then cast it to PassiveData.
func initialise(data_item: ItemData) -> void:
	super.initialise(data_item)
	# Cast the generic ItemData to PassiveData
	var passive_data: PassiveData = data_item as PassiveData
	data = passive_data
	current_boosts = passive_data.base_stats.boosts.duplicate()

# Get the current stat boosts this passive provides
func get_boosts() -> CharacterDataStats:
	return current_boosts

# Override the level up functionality to add stat boosts
func do_level_up() -> bool:
	super.do_level_up()
	
	# Prevent level up if already at max level
	if not can_level_up():
		push_warning("Cannot level up %s to Level %d, max level of %d already reached." % [name, current_level, data.max_level])
		return false
	
	
	# Otherwise, add stats of the next level to the passive
	current_level += 1
	var next_level_data: PassiveModifier = data.get_level_data(current_level) as PassiveModifier
	current_boosts = current_boosts.add(next_level_data.boosts)
	return true
