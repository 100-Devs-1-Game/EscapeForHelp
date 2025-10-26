extends Resource
class_name CharacterDataStats

@export var health: float
@export var regeneration: float
@export var weapon_damage: float
@export var tackle_damage: float
@export var defence: float
@export var dodge: float
@export var critical_chance: float
@export var critical_power: float
@export var attack_speed: float
@export var movement_speed: float
@export var pickup_radius: float
@export var experience_multiplier: float
@export var luck: float

func add(other: CharacterDataStats) -> CharacterDataStats:
	var result: CharacterDataStats = CharacterDataStats.new()
	result.health = self.health + other.health
	result.regeneration = self.regeneration + other.regeneration
	result.weapon_damage = self.weapon_damage + other.weapon_damage
	result.tackle_damage = self.tackle_damage + other.tackle_damage
	result.defence = self.defence + other.defence
	result.dodge = self.dodge + other.dodge
	result.critical_chance = self.critical_chance + other.critical_chance
	result.critical_power = self.critical_power + other.critical_power
	result.attack_speed = self.attack_speed + other.attack_speed
	result.movement_speed = self.movement_speed + other.movement_speed
	result.pickup_radius = self.pickup_radius + other.pickup_radius
	result.experience_multiplier = self.experience_multiplier + other.experience_multiplier
	result.luck = self.luck + other.luck
	return result
