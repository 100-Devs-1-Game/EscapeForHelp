extends LevelData
class_name PassiveModifier

@export var boosts: CharacterDataStats

func _init(n: String = "", desc: String = "", b: CharacterDataStats = null) -> void:
	name = n
	description = desc
	boosts = b if b != null else CharacterDataStats.new()
