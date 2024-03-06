extends Node

signal on_hit(from:CharacterBody3D, to: CharacterBody3D)
# Called when the node enters the scene tree for the first time.
func _ready():
	on_hit.connect(deal_damage_to)

func deal_damage_to(from: Entity, to: Entity):
	if to.is_class("Player"):
		if !to.check_self_authority():
			return
	to.current_hp -= from.damage
	if to.current_hp <= 0.00:
		to.die()
	
