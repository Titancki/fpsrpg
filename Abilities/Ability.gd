extends Resource
class_name AbilityResource

#@export var animation : String
#@export var ability_name : String
#@export var ability_description : String
#@export var entity : NodePath
#@export var is_interruptable : bool
#@export var effect_data : Dictionary
#
#var is_active : bool = false
#

## Called when the node enters the scene tree for the first time.
#func _ready():
	#pass # Replace with function body.
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#var current_animation = entity.animator.get_current_animation()
	#if is_active:
		#if current_animation != animation:
			#entity.animator.set_current_animation(animation)
