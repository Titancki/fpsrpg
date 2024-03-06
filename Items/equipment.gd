extends Node
var wielder : Entity


func _on_area_entered(area):
	if area.owner != wielder:
		if wielder is Player:
			if wielder.check_self_authority():
				wielder.is_attacking = false
		else:
			wielder.is_attacking = false
