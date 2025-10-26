class_name GameScreen
extends CanvasLayer

@export var exp_bar: ProgressBar
@export var lbl_level: Label
@export var health_bar: ProgressBar
@export var lbl_timer: Label
@export var lbl_counter: Label
@export var lbl_fps: Label
@export var collected_weapons: GridContainer
@export var collected_upgrades: GridContainer
@export var lbl_stats: Label

#Nodes for HealthBar script
@export var death_panel: Control
@export var lbl_result: Label

#Nodes for LevelUp panel
@export var level_up_panel: Control
@export var lbl_level_up: Label
@onready var snd_level_up: AudioStreamPlayer = $Control/Panels/LevelUp/PanelContainer/SndLevelUp
@export var upgrade_options_container: BoxContainer

var time: float = 0

func _ready() -> void:
	Global.game_screen = self

func _process(delta: float) -> void:
	time += delta
	_update_time(time)
	_update_fps(int(Engine.get_frames_per_second()))
	
func show_level_up() -> void:
	snd_level_up.play()
	level_up_panel.visible = true
	var tween: Tween = level_up_panel.create_tween()
	tween.tween_property(level_up_panel, "position", Vector2(430, 150), 0.2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)

func hide_level_up() -> void:
	var tween: Tween = level_up_panel.create_tween()
	tween.tween_property(level_up_panel, "position", Vector2(1200.0, 150), 0.2)
	level_up_panel.visible = false


func set_xp_bar(value: int, max_value: int) -> void:
	exp_bar.value = value
	exp_bar.max_value = max_value

func update_level(level: int) -> void:
	lbl_level.text = str("LV ", level)

func init_health_bar(max_health: int) -> void:
	health_bar.max_value = max_health
	health_bar.value = max_health

func update_health(hp: int, max_hp: int) -> void:
	health_bar.max_value = max_hp
	health_bar.value = hp

func show_death_screen(is_victory: bool) -> void:
	death_panel.visible = true
	get_tree().paused = true

	var tween: Tween = death_panel.create_tween()
	tween.tween_property(death_panel, "position", Vector2(220, 50), 3.0)

	if is_victory:
		lbl_result.text = "You Win"
	else:
		lbl_result.text = "You Lose"

func _update_time(current_time: float) -> void:
	var minutes: int = int(current_time / 60)
	var seconds: int = int(current_time) % 60
	lbl_timer.text = "%02d:%02d" % [minutes, seconds]
	
func _update_fps(count: int) -> void:
	lbl_fps.text = "%d" % count

func update_stats_display(stats: CharacterDataStats) -> void:
	if not lbl_stats:
		return

	var stats_text: String = ""
	stats_text += "HP: %.0f/%.0f\n" % [Global.player.player_stats.current_health, stats.health]
	stats_text += "Regen: %.1f/s\n" % stats.regeneration
	stats_text += "Defence: %.0f\n" % stats.defence
	stats_text += "Dodge: %.1f%%\n" % (stats.dodge * 100)
	stats_text += "\n"
	stats_text += "Weapon DMG: %.1fx\n" % stats.weapon_damage
	stats_text += "Tackle DMG: %.0f\n" % stats.tackle_damage
	stats_text += "Crit: %.1f%% (%.1fx)\n" % [stats.critical_chance * 100, stats.critical_power]
	stats_text += "Atk Speed: %.1fx\n" % stats.attack_speed
	stats_text += "\n"
	stats_text += "Move Speed: %.1fx\n" % stats.movement_speed
	stats_text += "Pickup: %.0f\n" % stats.pickup_radius
	stats_text += "XP Mult: %.1fx" % stats.experience_multiplier

	lbl_stats.text = stats_text
