extends AnimationTree

@onready var entity : Entity = $"../.."

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	set("parameters/movement/blend_position", entity.input_dir)
	set("parameters/conditions/is_falling", !entity.is_on_ground)
	set("parameters/conditions/is_on_ground", entity.is_on_ground)
	set("parameters/conditions/is_attacking", entity.is_attacking)
	set("parameters/attack_abilities/conditions/attack_has_ended", !entity.is_attacking)
	set("parameters/conditions/is_blocking", entity.is_blocking)
	set("parameters/conditions/stopped_block", !entity.is_blocking)
	set("parameters/block_abilities/conditions/stopped_block", !entity.is_blocking)
	
