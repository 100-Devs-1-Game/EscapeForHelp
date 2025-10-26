class_name PlayerInventory
extends Node

@export var passives: Node
@export var upgrade_manager: UpgradeManager

var item_container_scene: PackedScene = preload("res://scenes/ui/item_container.tscn")

# Constants for consumable items
const FOOD_CATEGORY: String = "Food"
const FOOD_HEAL_AMOUNT: float = 20.0

# Arrays for the inventory slots
# Weapon slots kept for UI purposes only - implementation will be done by another developer
var weapon_slots: Array[InventorySlot] = []
var passive_slots: Array[InventorySlot] = []

# Lists of upgrade options (set these up in the editor)
@export_group("Upgrade Options")
@export var available_passives: Array[PassiveData] = []

func _init() -> void:
	weapon_slots.resize(6)
	for i: int in range(6):
		weapon_slots[i] = InventorySlot.new()
		weapon_slots[i].container = item_container_scene.instantiate() as ItemContainer
	passive_slots.resize(6)
	for i: int  in range(6):
		passive_slots[i] = InventorySlot.new()
		passive_slots[i].container = item_container_scene.instantiate() as ItemContainer

func _ready() -> void:
	for slot: InventorySlot in weapon_slots:
		Global.game_screen.collected_weapons.add_child(slot.container)
	for slot: InventorySlot in passive_slots:
		Global.game_screen.collected_upgrades.add_child(slot.container)
		
# Returns true if an item of the specified type exists in the inventory.
func has(item_data: ItemData) -> bool:
	return get_item(item_data) != null

func get_item(item_data: ItemData) -> Item:
	if item_data is PassiveData:
		return get_passive(item_data)
	return null

func get_passive(passive_data: PassiveData) -> Item:
	for slot: InventorySlot in passive_slots:
		if slot.item and slot.item.data == passive_data:
			return slot.item
	return null

# Removes a passive from the inventory.
func remove_passive(item_data: ItemData, remove_upgrade_availability: bool = false) -> bool:
	if remove_upgrade_availability:
		available_passives.erase(item_data)
	for slot: InventorySlot in passive_slots:
		if slot.item and slot.item.data == item_data:
			#NOTE: This is to fix item getting added to 2nd free slot instead of 1st
			var temp_item: Item = slot.item
			slot.clear()
		
			# Call unequip and queue_free on the temporary reference
			temp_item.on_unequip()
			temp_item.queue_free()
			return true
	return false
	
func remove_item(item_data: ItemData, remove_upgrade_availability: bool = false) -> bool:
	if item_data is PassiveData:
		return remove_passive(item_data, remove_upgrade_availability)
	return false

# Adds a passive to the first empty passive slot.
func add_passive(data: PassiveData) -> int:
	# Handle consumable items (like Food) that provide immediate effects
	if data.base_stats.name == FOOD_CATEGORY:
		Global.player.player_stats.restore_health(FOOD_HEAL_AMOUNT)
		return -1
	var slot_num: int = -1
	for i: int in range(passive_slots.size()):
		if passive_slots[i].is_empty():
			slot_num = i
			break
	if slot_num < 0:
		return slot_num
		
	var passive_instance: Passive = Passive.new()
	passive_instance.name = "%s Passive" % data.base_stats.name
	passives.add_child(passive_instance)
	if passive_instance.has_method("set_position"):
		passive_instance.set_position(Vector3.ZERO)
	passive_instance.initialise(data)
	passive_slots[slot_num].assign(passive_instance)
	
	Global.player.player_stats.recalculate_stats()
	return slot_num

# Generic add function.
func add_item(data: ItemData) -> int:
	if data is PassiveData:
		return add_passive(data)
	return -1


# NOTE: level_up_item_data is unused, but could be useful.
func level_up_item_data(data: ItemData) -> bool:
	var item: Item = get_item(data)
	if item:
		return level_up_item(item)
	return false

func level_up_item(item: Item) -> bool:
	if not item.do_level_up():
		print("Failed to level up %s." % item.name)
		return false
		
	if item is Passive:
		Global.player.player_stats.recalculate_stats()

	return true


func get_slots_left(slots: Array[InventorySlot]) -> int:
	var count: int = 0
	for slot: InventorySlot in slots:
		if slot.is_empty():
			count += 1
	return count

func apply_upgrade_options() -> void:
	var available_upgrades: Array[ItemData] = []
	var all_upgrades: Array[ItemData] = []
	all_upgrades.append_array(available_passives)

	var passive_slots_left: int = get_slots_left(passive_slots)

	for item_data: ItemData in all_upgrades:
		var item: Item = get_item(item_data)
		if item:
			if item.current_level < item_data.max_level:
				available_upgrades.append(item_data)
		else:
			if item_data is PassiveData and passive_slots_left > 0:
				available_upgrades.append(item_data)

	if available_upgrades.size() > 0:
		upgrade_manager.set_upgrades(self, available_upgrades) #TODO: Maybe improve to go through game_screen, instead of doing it here
	else:
		upgrade_manager.set_upgrades(self, available_upgrades) #TODO: Add food and money when options are exhausted

func remove_and_apply_upgrades() -> void:
	apply_upgrade_options()
