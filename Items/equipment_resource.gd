extends ItemResource
class_name EquipmentResource

@export_category("Requirement")
@export var required_strength : int = 0
@export var required_agility : int = 0
@export var required_dexterity : int = 0

@export_category("Effects")
@export var flat_damage : float = 0
@export var multiplicative_damage : float = 1
@export var ability : Resource
@export var equipment_scene : PackedScene
var wielder

func can_equip() -> bool:
	#TO DO: compare stats with player from stats_ressources 
	return true
