extends Node
@export var address = "127.0.0.1"
@export var port = 8910
# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	
	if "--server" in OS.get_cmdline_args():
		host_game().call_deferred()
	$Net/ServerBrowser.joinGame.connect(JoinByIP)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
# Called on server and clients
func peer_connected(id):
	print("Player Connected " + str(id))

# Called on the server and clients
func peer_disconnected(id):
	print("Player Disconnected " + str(id))
	# Need to refacto, bug prone
	if id == 1:
		get_tree().quit() # Replace by main menu redirect
	System.players.erase(id)
	var players = get_tree().get_nodes_in_group("Player")
	for i in players:
		if i.name == str(id):
			i.queue_free()


# Called only from clients
func connected_to_server():
	print("Connected to server !")
	SendPlayerInformation.rpc_id(1, $Net/LineEdit.text, multiplayer.get_unique_id())

# Called only from clients
func connection_failed():
	print("Cannot connect")
	print("peer: " + str(multiplayer.get_multiplayer_peer()))

func host_game():
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port)
	if error != OK:
		print("cannot host: " + error)
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	print("Waiting For Players!")
	SendPlayerInformation($Net/LineEdit.text, multiplayer.get_unique_id())

func JoinByIP(ip):	
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(ip, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	start_game()

func start_game():
	# Hide the UI and unpause to start the game.
	$Net.hide()
	get_tree().paused = false
	# Only change level on the server.
	# Clients will instantiate the level via the spawner.
	if multiplayer.is_server():
		change_level.call_deferred(load("res://scenes/test_city.tscn"))


# Call this function deferred and only on the main authority (server).
func change_level(scene: PackedScene):
	# Remove old level if any.
	var level = $Level
	for c in level.get_children():
		level.remove_child(c)
		c.queue_free()
	# Add new level.
	level.add_child(scene.instantiate())

@rpc("any_peer")
func SendPlayerInformation(name, id):
	if !System.players.has(id):
		System.players[id] ={
			"name" : name,
			"id" : id,
			"score": 0
		}
	
	if multiplayer.is_server():
		for i in System.players:
			SendPlayerInformation.rpc(System.players[i].name, i)
