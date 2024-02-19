extends Node

func _ready():
	pass # Replace with function body.


static func attack(delta, entity):
	var animator = entity.get_node("Character/CharacterAnimation")
	var current_animation = animator.get_current_animation()
	if current_animation != "attack":
		animator.set_current_animation("attack")
