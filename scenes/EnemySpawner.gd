extends MultiplayerSpawner

@export var enemy_scenes := {
	"1" = "res://Entities/bandit/bandit.tscn"
}
@onready var spawn_point_0 = $"../EnemySpawnPoints/0".position


# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_function = spawn_enemy
	if multiplayer.get_unique_id() == 1:
		spawn({"id":"1", "pos":spawn_point_0})

func spawn_enemy(enemy_dict: Dictionary) -> Node:
	var id = enemy_dict["id"]
	var pos = enemy_dict["pos"]
	var enemy = load(enemy_scenes[id]).instantiate()
	enemy.position = pos
	return enemy
