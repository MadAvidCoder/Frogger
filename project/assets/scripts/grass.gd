extends Sprite2D

func _process(_delta: float) -> void:
	if global_position.y > 750:
		self.free()
