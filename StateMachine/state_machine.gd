extends Node
class_name StateMachine

enum STATE {MOVING, ATTACKING, CASTING, IDLING, JUMPING}

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var entity : CharacterBody3D
@export var current_state: STATE
@export var is_player: bool
@onready var moving = load("res://StateMachine/moving.gd") 
@onready var idling = load("res://StateMachine/idling.gd")
@onready var jumping = load("res://StateMachine/jumping.gd")
@onready var attacking = load("res://StateMachine/attacking.gd")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var animator = entity.get_node("Character/AnimationPlayer")
	var current_animation = animator.get_current_animation()
	if not entity.is_on_floor():
		if current_animation != "falling":
			animator.set_current_animation("falling")
	else:
		if current_state == STATE.JUMPING && entity.is_on_floor():
			jumping.entity = entity
			if is_player:
				jumping.jump(delta, entity)
		elif current_state == STATE.IDLING:
			idling.entity = entity
			if is_player:
				idling.player_idle(delta, entity)
		elif current_state == STATE.MOVING:
			moving.entity = entity
			if is_player:
				moving.player_move(delta, entity)
		elif current_state == STATE.ATTACKING:
			attacking.entity = entity
			if is_player:
				attacking.attack(delta, entity)
		elif current_state == STATE.CASTING:
			pass
		
	
	if not entity.is_on_floor():
		entity.velocity.y -= gravity * delta
		entity.move_and_slide()
	elif current_animation == "falling" && entity.is_on_floor():
		if current_animation != "jump_down":
			animator.set_current_animation("jump_down")
	
	if not Input.get_vector("left", "right", "forward", "backward"):
		entity.velocity.x = move_toward(entity.velocity.x, 0, 3.0)
		entity.velocity.z = move_toward(entity.velocity.z, 0, 3.0)
