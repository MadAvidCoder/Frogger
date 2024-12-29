extends Node2D

var top = -114.034
var next = 0
signal started(character)
var scroll = false
var begun = false
var needs_grass = false
var http
var http_response = ""
var columns = ["id","username","password","has_password","coins","high_score","skins"]

@onready var grass = preload("res://grass.tscn")
@onready var river = preload("res://river.tscn")
@onready var road = preload("res://road.tscn")
@onready var big_road = preload("res://big_road.tscn")
@onready var short_log = preload("res://short_log.tscn")
@onready var long_log = preload("res://long_log.tscn")

func _ready() -> void:
	$Shop.hide()
	$End.hide()
	$Start.show()
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

func _process(delta: float) -> void:
	if scroll:
		if next <= 0:
			var selected = randi_range(0,2)
			if selected == 0 or needs_grass:
				needs_grass = false
				var new = grass.instantiate()
				add_child(new)
				new.position = Vector2(576,top-60)
				top -= 120
				next = 120
			elif selected == 1:
				needs_grass = true
				var new = river.instantiate()
				add_child(new)
				var size = new.get_meta("lanes")*60
				new.position = Vector2(326,top-size)
				top -= size
				next = size
			else:
				if randi_range(0,1):
					needs_grass = true
					var new = road.instantiate()
					add_child(new)
					new.position = Vector2(576,top-90)
					top -= 180
					next = 180
				else:
					needs_grass = true
					var new = big_road.instantiate()
					add_child(new)
					new.position = Vector2(576,top-180)
					top -= 360
					next = 360
		position.y += delta*30
		next -= delta*30
		
	if not begun and Input.is_action_just_pressed("start"):
		_start_game()
	elif $End.visible == true and Input.is_action_just_pressed("start"):
		_restart_game()
	

func _scroll_screen(amount: Variant) -> void:
	if scroll:
		position.y += amount
		next -= amount

func _start_game() -> void:
	begun = true
	$Start.hide()
	$End.hide()
	started.emit("rabbit")
	scroll = true
	$Start.queue_free()

func _on_frog_ended() -> void:
	$Timer.start()

func _on_timer_timeout() -> void:
	$End.show()
	scroll = false

func _restart_game() -> void:
	get_tree().reload_current_scene()
