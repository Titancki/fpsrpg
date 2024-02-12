extends Area3D

var wielder
var targets_hitted = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_area_entered(area):
	var target = area.owner
	if target.is_in_group("Player") && target != wielder && wielder.is_attacking():
		Combat.on_hit.emit(wielder, target)
		targets_hitted.append(target)


func _on_area_exited(area):
	var target = area.owner
	if target.is_in_group("Player") && target != wielder:
		targets_hitted.erase(target)

