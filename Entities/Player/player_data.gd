extends Resource
class_name PlayerDataResource

@export var weapon_equiped : EquipmentResource
@export var offhand_equiped : EquipmentResource
@export var bodyarmour_equiped : EquipmentResource
@export var helmet_equiped : EquipmentResource
@export var belt_equiped : EquipmentResource
@export var troussers_equiped : EquipmentResource
@export var boots_equiped : EquipmentResource


func save():
	ResourceSaver.save(self, "res://Saves/player_data.tres")
