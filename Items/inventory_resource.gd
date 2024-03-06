extends Resource
class_name InventoryResource

@export var items : Dictionary

func save():
	ResourceSaver.save(self, "res://Saves/inventory.tres")
