# player_input.gd
extends MultiplayerSynchronizer

func _ready():
	# Only process for the local player.
	set_process(get_multiplayer_authority() == multiplayer.get_unique_id())

