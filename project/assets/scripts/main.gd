extends Node2D

var top = -114.034
var next = 0
signal started
var scroll = false
var begun = false
var needs_grass = false

@onready var grass = preload("res://grass.tscn")
@onready var river = preload("res://river.tscn")
@onready var road = preload("res://road.tscn")
@onready var short_log = preload("res://short_log.tscn")
@onready var long_log = preload("res://long_log.tscn")

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
				needs_grass = true
				var new = road.instantiate()
				add_child(new)
				new.position = Vector2(576,top-90)
				top -= 180
				next = 180
		position.y += delta*30
		next -= delta*30
		
	if not begun and Input.is_action_just_pressed("start"):
		_start_game()
	

func _scroll_screen(amount: Variant) -> void:
	if scroll:
		position.y += amount
		next -= amount

func _start_game() -> void:
	begun = true
	$Start.hide()
	$End.hide()
	started.emit()
	scroll = true
	$Start.queue_free()

func _on_frog_ended() -> void:
	$Timer.start()

func _on_timer_timeout() -> void:
	$End.show()
	scroll = false
