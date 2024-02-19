extends Node

signal on_hit(from:Player, to: Player)
# Called when the node enters the scene tree for the first time.
func _ready():
	on_hit.connect(deal_damage_to)

func deal_damage_to(from: Player, to: Player):
	print(from, "deal damage to ", to)
	if to.check_self_authority():
		print(to, " is authority")
		print(to.current_hp)
		to.current_hp -= from.damage
		if to.current_hp <= 0.00:
			to.die()
	
