extends CharacterBody3D
class_name Player

const JUMP_VELOCITY = 4.5
const CAMERA_SENSIBILITY = 0.0025
var cam_locked = false
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var camera := $LookingDirection/Camera3D
@onready var animator := $Character/AnimationPlayer
@onready var spine_marker = $LookingDirection/SpineMarker
@onready var spine = $Character/RootNode/Skeleton3D/SpineAttachement
@onready var skeleton = $Character/RootNode/Skeleton3D
@export var max_hp :float = 100
@export var current_hp :float = max_hp
@export var damage := 5.00
var has_been_hitted := false
@onready var rh_hatchement = $Character/RootNode/Skeleton3D/RightHandAttachement/Container
@export var player_id : int

func _ready():
	#var player_info = System.players[multiplayer.get_unique_id()]
	if check_self_authority():
		$Name.set_text("")
		$UI/peer_id.set_text(str(multiplayer.get_unique_id()))
		$Character/RootNode/Skeleton3D/Body.hide()
		$Character/RootNode/Skeleton3D/HeadAttachement.hide()
		$StateMachine.current_state = StateMachine.STATE.IDLING
	if $MultiplayerSynchronizer.get_multiplayer_authority() == 1:
		var new_sword = Equipment.sword
		new_sword.wielder = self
		rh_hatchement.add_child(new_sword)

func _enter_tree():
	# We set the authority after just before the player enters the scene
	player_id = str(name).to_int()
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())

func _unhandled_input(event: InputEvent) -> void:
	if check_self_authority():
		if event.is_action_pressed("ui_cancel"):
			cam_locked = !cam_locked
		if !cam_locked:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			if event is InputEventMouseMotion:
				rotate_y(-event.relative.x * CAMERA_SENSIBILITY)
				camera.rotate_x(-event.relative.y * CAMERA_SENSIBILITY)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(_delta: float) -> void:
	if check_self_authority():
		camera.current = true
		spine.global_transform = spine.global_transform.looking_at(spine_marker.global_position, Vector3.UP)
		spine.transform.origin = skeleton.get_bone_global_pose_no_override(
			skeleton.find_bone("mixamorig1_Spine")).origin
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(30))
		if Input.is_action_pressed("jump"):
			$StateMachine.current_state = StateMachine.STATE.JUMPING
		elif Input.is_action_pressed("mouse_left"):
			$StateMachine.current_state = StateMachine.STATE.ATTACKING
		elif (Input.get_vector("left", "right", "forward", "backward") && 
		$StateMachine.current_state != StateMachine.STATE.JUMPING):
			$StateMachine.current_state = StateMachine.STATE.MOVING
		else:
			$StateMachine.current_state = StateMachine.STATE.IDLING
		# "_no_override" to always get real pose of current anim frame without modifications you done

func is_attacking():
	if $StateMachine.current_state == StateMachine.STATE.ATTACKING:
		return true
	return false

func die():
	queue_free()
	get_tree().quit()

func check_self_authority():
	if player_id == get_multiplayer_id():
		return true
	return false

func get_multiplayer_id():
	return multiplayer.get_unique_id()
