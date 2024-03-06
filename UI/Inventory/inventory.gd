extends PanelContainer

@onready var grid = $GridContainer
var is_visble : bool = false
@export var inventory : InventoryResource


func _ready():
	load_inventory()
	
	
func _unhandled_input(event):
	if event.is_action_pressed("equip_1"):
		var new_item = load("res://Items/weapon/ressources/sword.tres")
		add_to_inventory(new_item)
	if event.is_action_pressed("equip_2"):
		var new_item = load("res://Items/weapon/ressources/hammer.tres")
		add_to_inventory(new_item)
	if event.is_action_pressed("special"):
		remove_from_inventory(3001)
		var new_item = load("res://Items/offhand/ressources/shield.tres")
		add_to_inventory(new_item)


func add_to_inventory(_item: ItemResource):
	var _item_id = _item.item_id
	if inventory.items.has(_item_id):
		inventory.items[_item_id]["amount"] += 1
	else:
		inventory.items[_item_id] = {
			"item" = _item,
			"amount" = 1
		}
		var new_item_slot = load("res://UI/Inventory/inventory_slot.tscn").instantiate()
		new_item_slot.item = _item
		new_item_slot.name = str(_item.item_id)
		grid.add_child(new_item_slot)
	grid.get_node(str(_item_id)).on_update_amount.emit(inventory.items[_item_id]["amount"])
	inventory.save()

func remove_from_inventory(_item_id : int):
	if inventory.items.has(_item_id):
		if inventory.items[_item_id]["amount"] > 1:
			inventory.items[_item_id]["amount"] -= 1
			grid.get_node(str(_item_id)).on_update_amount.emit(inventory.items[_item_id]["amount"])
		else:
			inventory.items.erase(_item_id)
			grid.get_node(str(_item_id)).queue_free()
	else:
		print(str(_item_id) + " does not exist in inventory")
	inventory.save()

func load_inventory():
	inventory = load("res://Saves/inventory.tres")
	for item_key in inventory.items:
		var item = inventory.items[item_key]["item"]
		var amount = inventory.items[item_key]["amount"]
		var new_item_slot = load("res://UI/Inventory/inventory_slot.tscn").instantiate()
		new_item_slot.item = item
		new_item_slot.name = str(item_key)
		grid.add_child(new_item_slot)
		grid.get_node(str(item_key)).on_update_amount.emit(amount)
		grid.get_node(str(item_key)).on_update_icon.emit(item.item_icon_texture)
		

