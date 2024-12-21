extends Node2D

var top = 0
var bottom = 648
var next_chunk = ""
var chunks = [
	{
		"type": "grass",
		"position": Vector2(576, 566.75),
		"size": Vector2(500, 162.5),
		"contents": []
	},
	{
		"type": "river",
		"position": Vector2(576, 396.7),
		"size": Vector2(500, 177.6),
		"contents": []
	}
]
@onready var grass = preload("res://grass.tscn")
@onready var river = preload("res://river.tscn")
@onready var short_log = preload("res://short_log.tscn")
@onready var long_log = preload("res://long_log.tscn")

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass
