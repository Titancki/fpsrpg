extends Node

static var entity
static var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

static func player_move(delta, entity):
	var animator = entity.get_node("Character/AnimationPlayer")
	var current_animation = animator.get_current_animation()
	var speed = 3.0

	if Input.is_action_pressed("forward"):
		if current_animation != "walk" && !Input.is_action_pressed("move_action"):
			animator.set_current_animation("walk")
		# potential futur change
		elif Input.is_action_pressed("move_action"):
			speed = 7.0
			if current_animation != "run":
				animator.set_current_animation("run")
	elif Input.is_action_pressed("right"):
		speed = 2.0
		if current_animation != "strafe_right":
				animator.set_current_animation("strafe_right")
	elif Input.is_action_pressed("left"):
		speed = 2.0
		if current_animation != "strafe_left":
				animator.set_current_animation("strafe_left")
	elif Input.is_action_pressed("backward"):
		speed = 2.0
		if current_animation != "backward":
				animator.set_current_animation("backward")
	else:
		pass
	
	
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction = (entity.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		entity.velocity.x = direction.x * speed
		entity.velocity.z = direction.z * speed
	entity.move_and_slide()
