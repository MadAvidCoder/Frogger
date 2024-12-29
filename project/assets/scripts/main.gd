extends Node2D

var top = -114.034
var next = 0
signal started(character)
var scroll = false
var begun = false
var needs_grass = false

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
	if Global.skin == 0:
		get_tree().call_group("Frog", "show")
		get_tree().call_group("Rabbit", "hide")
	if Global.skin == 1:
		get_tree().call_group("Frog", "hide")
		get_tree().call_group("Rabbit", "show")

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
		
	if not begun:
		if Input.is_action_just_pressed("start"):
			_start_game()
		elif Input.is_action_just_pressed("right"):
			_on_arrow_right_pressed()
		elif Input.is_action_just_pressed("left"):
			_on_arrow_left_pressed()
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
	if Global.skin == 0:
		started.emit("frog")
		get_tree().call_group("Frog", "show")
		get_tree().call_group("Rabbit", "hide")
	elif Global.skin == 1:
		started.emit("rabbit")
		get_tree().call_group("Frog", "hide")
		get_tree().call_group("Rabbit", "show")
	scroll = true
	$Start.queue_free()

func _on_frog_ended() -> void:
	$Timer.start()

func _on_timer_timeout() -> void:
	$End.show()
	scroll = false

func _restart_game() -> void:
	get_tree().reload_current_scene()

func _on_arrow_left_pressed() -> void:
	Global.skin -= 1
	if Global.skin == -1:
		Global.skin = 1
	if Global.skin == 0:
		get_tree().call_group("Frog", "show")
		get_tree().call_group("Rabbit", "hide")
	elif Global.skin == 1:
		get_tree().call_group("Frog", "hide")
		get_tree().call_group("Rabbit", "show")

func _on_arrow_right_pressed() -> void:
	Global.skin += 1
	if Global.skin == 2:
		Global.skin = 0
	if Global.skin == 0:
		get_tree().call_group("Frog", "show")
		get_tree().call_group("Rabbit", "hide")
	if Global.skin == 1:
		get_tree().call_group("Frog", "hide")
		get_tree().call_group("Rabbit", "show")
