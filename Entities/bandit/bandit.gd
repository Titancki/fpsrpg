extends CharacterBody3D
class_name Bandit

const JUMP_VELOCITY : float = 4.5
const SPEED : float = 3
const CAMERA_SENSIBILITY : float = 0.0025
var cam_locked: bool = false
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var animator := $Character/CharacterAnimation
@onready var spine = $Character/RootNode/Skeleton3D/SpineAttachement
@onready var skeleton = $Character/RootNode/Skeleton3D
@export var max_hp :float = 100
@export var current_hp :float = max_hp
@export var damage :float = 5.00
var has_been_hitted :bool = false
@onready var rh_hatchement = $Character/RootNode/Skeleton3D/RightHandAttachement/Container
@onready var nav_agent = $NavigationAgent3D
@export var agro_range : float = 100

func _ready():
		$StateMachine.current_state = StateMachine.STATE.IDLING
		var new_sword = Equipment.sword
		new_sword.wielder = self
		rh_hatchement.add_child(new_sword)
		

		#rotate_y(-event.relative.x * CAMERA_SENSIBILITY)
		#looking_direction.rotate_x(-event.relative.y * CAMERA_SENSIBILITY)

func _physics_process(delta: float) -> void:
		
		var players = get_tree().get_nodes_in_group("Player")
		var closest_player : Player
		#Set this in State machine (Searching).
		for player in players:
			if player.global_position.distance_to(global_position) <= agro_range:
				if closest_player == null :
					closest_player = player
				elif player.global_position.distance_to(global_position) <= player.global_position.distance_to(closest_player.global_position):
					closest_player = player
		
		if closest_player && !is_attacking():
			$StateMachine.current_state = StateMachine.STATE.MOVING
			var next_location = nav_agent.get_next_path_position()
			var new_velocity = (next_location - global_position).normalized() * SPEED
			velocity = velocity.move_toward(new_velocity, .25)
			move_and_slide()
			
		if closest_player == null && !is_attacking():
			$StateMachine.current_state = StateMachine.STATE.IDLING
		
		
		#spine.global_transform = spine.global_transform.looking_at(spine_marker.global_position, Vector3.UP)
		#spine.transform.origin = skeleton.get_bone_global_pose_no_override(
			#skeleton.find_bone("mixamorig1_Spine")).origin
		#if Input.is_action_pressed("jump"):
			#$StateMachine.current_state = StateMachine.STATE.JUMPING
		#elif Input.is_action_pressed("mouse_left"):
			#$StateMachine.current_state = StateMachine.STATE.ATTACKING
		#elif (Input.get_vector("left", "right", "forward", "backward") && 
		#$StateMachine.current_state != StateMachine.STATE.JUMPING):
			#$StateMachine.current_state = StateMachine.STATE.MOVING
		#else:
			#$StateMachine.current_state = StateMachine.STATE.IDLING

func is_attacking():
	if $StateMachine.current_state == StateMachine.STATE.ATTACKING:
		return true
	return false

func die():
	queue_free()
	get_tree().quit()

func _on_navigation_agent_3d_target_reached():
	$StateMachine.current_state = StateMachine.STATE.ATTACKING
