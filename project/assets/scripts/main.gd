extends Node2D

var top = -114.034
var last_top = -114.034
var last_size = 120
signal started
var scroll = false

@onready var grass = preload("res://grass.tscn")
@onready var river = preload("res://river.tscn")
@onready var road = preload("res://road.tscn")
@onready var short_log = preload("res://short_log.tscn")
@onready var long_log = preload("res://long_log.tscn")

func _process(delta: float) -> void:
	if scroll:
		position.y += delta*20
		top += delta*20
		if top > last_top-last_size:
			var selected = randi_range(0,2)
			if selected == 0 or last_size == 180:
				var new = grass.instantiate()
				add_child(new)
				new.position = Vector2(576,top-60)
				top -= 120
				last_top = top
				last_size = 120
			elif selected == 1:
				var new = river.instantiate()
				add_child(new)
				new.position = Vector2(576,top-90)
				top -= 180
				last_top = top
				last_size = 180
			else:
				var new = road.instantiate()
				add_child(new)
				new.position = Vector2(576,top-90)
				top -= 180
				last_top = top
				last_size = 180

func _start_game() -> void:
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
