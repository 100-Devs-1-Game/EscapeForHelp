extends ItemData
class_name PassiveData

# Base stats for the passive item
@export var base_stats: PassiveModifier = PassiveModifier.new()

# Growth stats for each level
@export var growth: Array[PassiveModifier] = []

# Gets the stats for a specific level
func get_level_data(level: int) -> PassiveModifier:
	if level <= 1:
		return base_stats
	
	# Pick the stats from the next level
	if level - 2 < growth.size():
		return growth[level - 2]
	
	# Return an empty value and a warning
	push_warning("Passive doesn't have its level up stats configured for Level %d!" % level)
	return PassiveModifier.new()
