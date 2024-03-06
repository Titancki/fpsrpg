extends Entity
class_name Bandit

@export var weapon : EquipmentResource

func _ready():
	speed = 3.0
	humanoid.spine.set_override_pose(false)
	equip(humanoid.right_hand, weapon)

func _physics_process(_delta: float) -> void:
	$Hp.text = str(snappedi(current_hp, 1)) + "/" + str(snappedi(max_hp, 1))
	is_on_ground = is_on_floor()
	$CurrentState.text = str(AI.STATE.keys()[$AI.current_state])

func _on_attack_delay_timeout():
	is_attacking = false


func _on_tree_exiting():
	pass # Replace with function body.
