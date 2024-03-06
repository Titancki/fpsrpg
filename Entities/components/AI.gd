extends Node
class_name AI

@export var agro_range : float = 20
@export var hit_range : float = 1.2
@onready var entity : Entity = $".."
@onready var nav_agent : NavigationAgent3D = $"../NavigationAgent3D"
enum STATE {IDLING, CHASING, ATTACKING}
@export var current_state = STATE.IDLING
var direction


# Called when the node enters the scene tree for the first time.
func _ready():
	entity.is_on_ground = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var target = get_closest_player()
	if target:
		if entity.global_position.distance_to(target.global_position) <= hit_range:
			current_state = STATE.ATTACKING
		elif !entity.is_attacking:
			current_state = STATE.CHASING
	else:
		current_state = STATE.IDLING
	
	
	match current_state:
		
		STATE.IDLING:
			entity.input_dir.x = 0
		
		STATE.ATTACKING:
			entity.speed = 0
			entity.input_dir.y = 0
			if !entity.is_attacking: # New attack
				var ground_target = Vector3(target.global_position.x, entity.global_position.y, target.global_position.z)
				entity.transform = entity.transform.looking_at(ground_target, Vector3.UP)
				entity.is_attacking = true
				entity.get_node("AttackDelay").start()
		
		STATE.CHASING:
			entity.speed = 3
			var ground_target = Vector3(target.position.x, entity.position.y, target.position.z)
			entity.transform = entity.transform.looking_at(ground_target, Vector3.UP)
			nav_agent.set_target_position(target.global_position)
			entity.input_dir.y = -1
			
			var next_pos = nav_agent.get_next_path_position()
			entity.direction = entity.transform.origin.direction_to(next_pos)
			
			if entity.direction:
				entity.velocity.x = entity.direction.x * entity.speed
				entity.velocity.z = entity.direction.z * entity.speed
				
			entity.move_and_slide()
			

func get_closest_player() -> Player :
	var players = get_tree().get_nodes_in_group("Player")
	var closest_player
	
	for player in players:
		var dist_to_player = player.global_position.distance_to(entity.global_position)
		
		if dist_to_player <= agro_range:
			if !closest_player || dist_to_player < closest_player.global_position.distance_to(entity.global_position):
				closest_player = player
				
	return closest_player
