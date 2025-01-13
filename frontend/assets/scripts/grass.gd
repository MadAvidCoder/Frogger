extends Sprite2D

var caught = false

func _ready() -> void:
	if randf() < 0.33:
		if $"..".scroll:
			if Global.skin == 0:
				$Butterfly.show()
				$Butterfly.position = Vector2(randf_range(-1848.0,1848.0), randf_range(-360.0,360.0))
			elif Global.skin == 1:
				$Carrot.show()
				$Carrot.position = Vector2(randf_range(-1848.0,1848.0), randf_range(-360.0,360.0))
			elif Global.skin == 2:
				$Acorn.show()
				$Acorn.position = Vector2(randf_range(-1848.0,1848.0), randf_range(-360.0,360.0))

func _process(_delta: float) -> void:
	if global_position.y > 750:
		self.free()
		caught = true
	if not caught:
		if "Frog" in str($Butterfly/ButterflyArea.get_overlapping_areas()):
			$Butterfly.queue_free()
			$"../Frog".score_num += 5
			caught = true
		elif "Rabbit" in str($Carrot/CarrotArea.get_overlapping_areas()):
			$Carrot.queue_free()
			$"../Rabbit".score_num += 5
			caught = true
		elif "Squirrel" in str($Acorn/AcornArea.get_overlapping_areas()):
			$Acorn.queue_free()
			$"../Squirrel".score_num += 5
			caught = true
