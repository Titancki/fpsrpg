extends Node

static var is_finished = false

func _ready():
	pass # Replace with function body.


static func jump(delta, entity):
	var animator = entity.get_node("Character/CharacterAnimation")
	var current_animation = animator.get_current_animation()
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction = (entity.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		entity.velocity.x = direction.x * 3.0
		entity.velocity.z = direction.z * 3.0

	if entity.is_on_floor():
		entity.velocity.y = entity.JUMP_VELOCITY
		if current_animation != "jump_up":
			animator.set_current_animation("jump_up")
		entity.move_and_slide()
	
