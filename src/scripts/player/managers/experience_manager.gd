class_name ExperienceManager
extends Node

var experience: int = 0
var experience_level: int = 1
var collected_experience: int = 0  # Persistent between gems

@export var upgrade_manager: UpgradeManager
@export var player_inventory: PlayerInventory

func _ready() -> void:
	Global.game_screen.update_level(experience_level)

func calculate_experience(gem_exp: int) -> void:
	var multiplied_exp: int = int(gem_exp * Global.player.player_stats.actual_stats.experience_multiplier)
	collected_experience += multiplied_exp
	_process_experience()

func _process_experience() -> void:
	while collected_experience > 0:
		var exp_required: int = _calculate_experiencecap()
		var remaining: int = exp_required - experience
		
		if collected_experience >= remaining:
			# Process ONE level-up at a time
			experience_level += 1
			experience = 0
			collected_experience -= remaining
			await _on_level_up(experience_level)
			Global.game_screen.set_xp_bar(experience, exp_required)
		else:
			experience += collected_experience
			collected_experience = 0
			Global.game_screen.set_xp_bar(experience, exp_required)
			break

		# Add a small delay to prevent frame stacking
		await get_tree().create_timer(0.1).timeout

func _calculate_experiencecap() -> int:
	if experience_level < 20:
		return experience_level * 5
	if experience_level < 40:
		return 95 + (experience_level - 19) * 8
	return 255 + (experience_level - 39) * 12

func _on_level_up(new_level: int) -> void:
	Global.game_screen.update_level(new_level)
	Global.game_screen.show_level_up()
	player_inventory.apply_upgrade_options()
	get_tree().paused = true
	# Wait for the upgrade selection to complete
	await upgrade_manager.upgrade_selected

	get_tree().paused = false
	Global.game_screen.hide_level_up()

func _on_grabber_area_entered(area: ExperienceGem) -> void:
	if area.is_in_group("loot"):
		area.target = Global.player

func _on_collector_area_entered(area: ExperienceGem) -> void:
	if area.is_in_group("loot"):
		var gem_xp: int = area.collect()
		calculate_experience(gem_xp)
