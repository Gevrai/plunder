extends Node

const PORT = 6789
const MAX_PLAYERS = 6

@export var player_scene: PackedScene
@export var player_root_tree: Node

func _on_host_pressed():
	%MultiplayerMenu.hide()

	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT, MAX_PLAYERS)
	if error != OK:
		print("Failed to start server: ", error)
		return
	multiplayer.multiplayer_peer = peer

	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)

	_spawn_player(multiplayer.get_unique_id())

	upnp_setup()

func _on_join_pressed():
	%MultiplayerMenu.hide()
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client("localhost", PORT)
	if error != OK:
		print("Failed to connect to server: ", error)
		return
	multiplayer.multiplayer_peer = peer

func _on_peer_connected(id: int):
	if multiplayer.is_server():
		_spawn_player(id)

func _on_peer_disconnected(id: int):
	var player = player_root_tree.get_node_or_null(str(id))
	if player:
		player.queue_free()

@rpc("any_peer")
func request_spawn():
	if !multiplayer.is_server():
		return
	_spawn_player(multiplayer.get_remote_sender_id())

func _spawn_player(id: int):
	var player = player_scene.instantiate()
	player.name = str(id)
	player_root_tree.add_child(player, true)

func upnp_setup():
	var upnp = UPNP.new()
	
	var discover_result = upnp.discover()
	assert(discover_result == UPNP.UPNP_RESULT_SUCCESS, \
		"UPNP Discover Failed! Error %s" % discover_result)

	assert(upnp.get_gateway() and upnp.get_gateway().is_valid_gateway(), \
		"UPNP Invalid Gateway!")

	var map_result = upnp.add_port_mapping(PORT)
	assert(map_result == UPNP.UPNP_RESULT_SUCCESS, \
		"UPNP Port Mapping Failed! Error %s" % map_result)
	
	print("Success! Join Address: %s" % upnp.query_external_address())
