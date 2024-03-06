extends CharacterBody3D
class_name Entity

const JUMP_VELOCITY : float = 4.5
const CAMERA_SENSIBILITY : float = 0.003
@export var speed: float = 2.0
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var humanoid = $Humanoid
@onready var looking_direction = $LookingDirection
@onready var spine_marker = $LookingDirection/SpineMarker
@export var max_hp :float = 100
@export var current_hp :float = max_hp
@export var damage :float = 5.00
var has_been_hitted :bool = false
var direction : Vector3

@export var is_attacking : bool = false
@export var is_blocking : bool = false
@export var input_dir: Vector2
@export var is_on_ground: bool = true

func die():
	queue_free()

func _on_hitbox_area_entered(area):
	if area.is_in_group("DamageSource"):
		var wielder = area.wielder
		if self != wielder:
			Combat.on_hit.emit(wielder, self)

func equip(socket: BoneAttachment3D, equipment : EquipmentResource):
	var container = socket.get_node("Container")
	var equip_id = equipment.item_id
	if container.get_child_count() == 0 || container.get_children()[0].name != str(equip_id):
		desequip( socket)
		var new_equip = equipment.equipment_scene.instantiate()
		new_equip.wielder = self
		new_equip.name = str(equip_id)
		container.add_child(new_equip)

func desequip( socket: BoneAttachment3D):
	var container = socket.get_node("Container")
	
	if container.get_child_count() > 0:
		container.get_children()[0].queue_free()
