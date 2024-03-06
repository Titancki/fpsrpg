extends Entity
class_name Player

@export var player_id : int
var cam_locked: bool = false
var player_data

func _enter_tree():
	player_id = str(name).to_int()
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	$Humanoid/RootNode/Skeleton3D/RightHand/Synchronizer.set_multiplayer_authority(str(name).to_int())
	$Humanoid/RootNode/Skeleton3D/Spine/Synchronizer.set_multiplayer_authority(str(name).to_int())
	$InputSynchronizer.set_multiplayer_authority(str(name).to_int())

func _ready():
	player_data = load("res://Saves/player_data.tres")
	if check_self_authority():
		var ui = load("res://UI/player_ui.tscn").instantiate()
		add_child(ui)
		$Name.set_text("")
		$UI/peer_id.set_text(str(multiplayer.get_unique_id()))
		$Humanoid/RootNode/Skeleton3D/Body.hide()
		$Humanoid/RootNode/Skeleton3D/Head.hide()

func _unhandled_input(event: InputEvent) -> void:
	if check_self_authority():
		if event.is_action_pressed("ui_cancel"):
			cam_locked = !cam_locked
		
		if !cam_locked:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			if event is InputEventMouseMotion:
				# "Clamping" issue with borderless Shadow PC
				rotate_y(-event.relative.x * CAMERA_SENSIBILITY) 
				looking_direction.rotate_x(-event.relative.y * CAMERA_SENSIBILITY)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta: float) -> void:
	if player_data.weapon_equiped:
		equip(humanoid.right_hand, player_data.weapon_equiped)
	else:
		desequip(humanoid.right_hand)
	
	if player_data.offhand_equiped:
		equip(humanoid.left_hand, player_data.offhand_equiped)
	else:
		desequip(humanoid.left_hand)
		
	if check_self_authority():
		$LookingDirection/Camera3D.current = true
		humanoid.spine.global_transform = humanoid.spine.global_transform.looking_at(spine_marker.global_position, Vector3.UP)
		humanoid.spine.transform.origin = humanoid.skeleton.get_bone_global_pose_no_override(
			humanoid.skeleton.find_bone("mixamorig1_Spine")).origin
		looking_direction.rotation.x = clamp(looking_direction.rotation.x, deg_to_rad(-60), deg_to_rad(30))
		is_on_ground = is_on_floor()
		if Input.is_action_pressed("mouse_left") && !is_attacking:
			is_attacking = true
			$AttackDelay.start()
		if Input.is_action_pressed("mouse_right"):
			is_attacking = false
			is_blocking = true
		else:
			is_blocking = false
			
		move(delta)

func move(delta):
	speed = 2.0
	if Input.is_action_pressed("forward"):
		speed = speed * 2
	input_dir = Input.get_vector("left", "right", "forward", "backward")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if is_attacking:
		speed = speed * 0.5
	
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = 0
		velocity.z = 0
	
	if is_on_floor() && Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY
	elif !is_on_floor():
		velocity.y -= gravity * delta
	
	move_and_slide()

func check_self_authority():
	if player_id == get_multiplayer_id():
		return true
	return false

func get_multiplayer_id():
	return multiplayer.get_unique_id()

func _on_attack_delay_timeout():
	if check_self_authority():
		is_attacking = false


