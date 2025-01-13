extends Node

func _ready() -> void:
	var peer = WebSocketMultiplayerPeer.new()
	var cert = X509Certificate.new()
	cert.load("res://fullchain.cer")
	var key = CryptoKey.new()
	key.load("res://privkey.key")
	peer.create_server(45381, "*", TLSOptions.server(key,cert))
	multiplayer.multiplayer_peer = peer

func read_file():
	var file = FileAccess.open("user://frogger_users.dat", FileAccess.READ)
	var content = JSON.parse_string(file.get_as_text())
	return content

func write_file(data):
	var file = FileAccess.open("user://frogger_users.dat", FileAccess.WRITE)
	file.store_string(JSON.stringify(data))

@rpc("any_peer", "call_remote", "unreliable")
func new_user(username, password):
	var to_add = {
		username: {
			"coins": 0,
			"high_score": 0,
			"password": password,
			"skins": []
		}
	}
	var users = read_file()
	users.merge(to_add)
	write_file(users)

@rpc("any_peer", "call_remote", "unreliable")
func edit_user(username, column, value):
	var users = read_file()
	users[username][column] = value
	write_file(users)

@rpc("any_peer", "call_remote", "unreliable")
func get_all_users(id):
	var users = read_file().keys()
	receive_all_users.rpc(users, id)

@rpc("authority", "call_local", "unreliable")
func receive_all_users(_users, _target):
	pass

@rpc("any_peer", "call_remote", "unreliable")
func get_leaderboard(id):
	var users = read_file()
	var keys = users.keys()
	var result = []
	keys.sort_custom(func(a, b): return users[a]["high_score"] > users[b]["high_score"])
	for i in keys:
		result.append([i, str(users[i]["high_score"])])
	receive_leaderboard.rpc(result, id)

@rpc("authority", "call_local", "unreliable")
func receive_leaderboard(_board, _target):
	pass

@rpc("any_peer", "call_remote", "unreliable")
func get_user_info(username, column, id):
	receive_leaderboard.rpc(read_file()[username][column], id)

@rpc("authority", "call_local", "unreliable")
func receive_user_info(_info, _target):
	pass
