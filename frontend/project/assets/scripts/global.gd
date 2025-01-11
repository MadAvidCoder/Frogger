extends Node2D

var user: String = ""
var skin: int = 0
var coins: int
var high_score: int
var skins = []
var id: int

func _ready() -> void:
	randomize()
	id = randi()
