extends Node2D

var http
var http_response: String = ""
const columns: PackedStringArray = ["id","username","password","has_password","coins","high_score","skins"]
var user: String = ""
var skin: int = 0
var coins: int
var high_score: int
var skins = []

func _ready() -> void:
	http = HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(self._http_request_completed)
	http.use_threads = true

func new_user(username: String, password: String = "") -> void:
	if password:
		await http_request("https://froggerapi.madavidcoder.hackclub.app/?new=true&username=%s&has_password=true&password=%s" % [username,password],"post")
	else:
		await http_request("https://froggerapi.madavidcoder.hackclub.app/?new=true&username=%s&has_password=false" % username,"post")

func edit_user(username: String, column: String, value: Variant) -> void:
	await http_request("https://froggerapi.madavidcoder.hackclub.app/?new=false&username=%s&column=%s&value=%s" % [username,column,value],"post")

func get_all_users() -> PackedStringArray:
	var resp = await http_request("https://froggerapi.madavidcoder.hackclub.app/?all=true","get")
	resp = resp.split(",")
	return resp

func get_leaderboard():
	var resp = await http_request("https://froggerapi.madavidcoder.hackclub.app/?all=true&board=true","get")
	resp = Array(resp.split(","))
	for i in range(len(resp)):
		resp[i] = resp[i].split(":")
	return resp

func get_user_info(username: String, column: String = "") -> Variant:
	var resp = await http_request("https://froggerapi.madavidcoder.hackclub.app/?username=%s" % username,"get")
	while "'" in resp:
		resp = resp.replace("'","")
	resp = resp.split(", ")
	if column:
		return resp[columns.find(column)]
	return resp

func http_request(url: String, method: String) -> String:
	if method == "get":
		http.request(url)
	else:
		http.request(url, PackedStringArray(), HTTPClient.METHOD_POST)
	await http.request_completed
	return http_response

func _http_request_completed(_result, _response_code, _headers, body):
	http_response = body.get_string_from_utf8()
