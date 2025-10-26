extends Resource
class_name InventorySlot
var item: Item = null
var image: TextureRect = null
var container: ItemContainer = null

func assign(assigned_item: Item) -> void:
	item = assigned_item
	if container:
		container.assign_item(assigned_item)
	else:
		print("Warning: container is not set!")
	print("Assigned %s to player." % item.name)

func clear() -> void:
	item = null
	if container:
		container.clear_item()
	else:
		print("Warning: container is not set!")

func is_empty() -> bool:
	return item == null
