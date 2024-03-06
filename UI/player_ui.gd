extends Control

@onready var player = $".."
# Called when the node enters the scene tree for the first time.
func _ready():
	if player.check_self_authority():
		$hp_bar.value = player.current_hp


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$Skills/move_action/active.hide()
	if Input.is_action_pressed("move_action"):
		$Skills/move_action.pressed.emit()
	if Input.is_action_just_pressed("inventory"):
		if $EquipmentPanel.is_visible():
			$EquipmentPanel.hide()
		else:
			$EquipmentPanel.show()
		$EquipmentPanel.get_node("BagOpening").play()
	if player.check_self_authority():
		$hp_bar.value = player.current_hp
	
	
func _on_move_action_pressed():
	$Skills/move_action/active.show()
