extends MultiplayerSpawner

#@export var enemy_scenes := {}
#
## Called when the node enters the scene tree for the first time.
#func _ready():
	#spawn_function = spawn_enemy
	#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _input(event : InputEvent):
	#if event.is_action_pressed("equip_1") && multiplayer.get_unique_id() == 1:
		#spawn({"id":"1", "pos": Vector3(0, 5, 0)})
#
#func spawn_enemy(enemy_dict: Dictionary) -> Node:
	#var id = enemy_dict["id"]
	#var pos  = enemy_dict["pos"]
	#var enemy = enemy_scenes[id].instantiate()
	#enemy.position = pos
	#return enemy
