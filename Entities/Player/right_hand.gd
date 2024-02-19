extends BoneAttachment3D

@onready var container = $Container
@onready var player = $"../../../.."
@export var current_equipment = {}:
	set(value):
		current_equipment = value
		if value:
			Equipment.on_equip.emit(value, player, self)
		else:
			Equipment.on_desequip.emit(player, self)
			
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _unhandled_input(event: InputEvent) -> void:
	if player.check_self_authority():
		if event.is_action_pressed("equip_1"):
			current_equipment = Equipment.all.sword
			pass
		elif event.is_action_pressed("equip_2"):
			current_equipment = Equipment.all.hammer
	pass



