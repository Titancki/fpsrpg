extends Node

var all = {
	sword = {
		id = 1,
		path = "res://Equipment/sword.tscn",
		name = "Sword"
	},
	hammer = {
		id = 2,
		path = "res://Equipment/hammer.tscn",
		name = "Hammer"
	}
}

signal on_equip(player : Player, equipment: Dictionary, socket: BoneAttachment3D)
signal on_desequip(player: Player, socket: BoneAttachment3D)

func _ready():
	on_equip.connect(equip)
	on_desequip.connect(desequip)


func equip(equipment: Dictionary, player: Player, socket: BoneAttachment3D):
	var container = socket.get_node("Container")
	
	if container.get_child_count() == 0 || container.get_children()[0].equip_id != equipment.id:
		desequip(player, socket)
		var new_equip = load(equipment.path).instantiate()
		new_equip.wielder = player
		new_equip.equip_id = equipment.id
		new_equip.equip_name = equipment.name
		container.add_child(new_equip, true)

func desequip(player: Player, socket: BoneAttachment3D):
	var container = socket.get_node("Container")
	
	if container.get_child_count() > 0:
		container.get_children()[0].queue_free()
