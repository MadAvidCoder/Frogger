extends Node2D

var http
var http_response = ""
var columns = ["id","username","password","has_password","coins","high_score","skins"]
var user
var skin = 0

func _ready() -> void:
	http = HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(self._http_request_completed)

func new_user(username, password=false):
	if password:
		await http_request("https://froggerapi.madavidcoder.hackclub.app/?new=true&username=%s&has_password=true&password=%s" % [username,password],"post")
	else:
		await http_request("https://froggerapi.madavidcoder.hackclub.app/?new=true&username=%s&has_password=false" % username,"post")

func edit_user(username, column, value):
	await http_request("https://froggerapi.madavidcoder.hackclub.app/?new=false&username=%s&column=%s&value=%s" % [username,column,value],"post")

func get_all_users():
	var resp = await http_request("https://froggerapi.madavidcoder.hackclub.app/?all=true","get")
	resp = resp.split(", ")
	return resp

func get_user_info(username,column=false):
	var resp = await http_request("https://froggerapi.madavidcoder.hackclub.app/?username=%s" % username,"get")
	while "'" in resp:
		resp = resp.replace("'","")
	resp = resp.split(", ")
	if column:
		return resp[columns.find(column)]
	return resp

func http_request(url, method):
	if method == "get":
		http.request(url)
	else:
		http.request(url, PackedStringArray(), HTTPClient.METHOD_POST)
	await http.request_completed
	return http_response

func _http_request_completed(result, response_code, headers, body):
	http_response = body.get_string_from_utf8()
