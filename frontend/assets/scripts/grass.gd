extends Sprite2D

var caught = false
var first

func _ready() -> void:
	if $"..".scroll:
		if randf() < 0.33 or $"..".time_since == 5:
			if Global.skin == 0:
				$Butterfly.show()
				$Butterfly.position = Vector2(randf_range(-1848.0,1848.0), randf_range(-360.0,360.0))
			elif Global.skin == 1:
				$Carrot.show()
				$Carrot.position = Vector2(randf_range(-1848.0,1848.0), randf_range(-360.0,360.0))
			elif Global.skin == 2:
				$Acorn.show()
				$Acorn.position = Vector2(randf_range(-1848.0,1848.0), randf_range(-360.0,360.0))
			$"..".time_since = 0
		else:
			$"..".time_since += 1
	elif region_rect.size.y == 960:
		first = Vector2(randf_range(-1848.0,1848.0), randf_range(-360.0,360.0))

func _process(_delta: float) -> void:
	if global_position.y > 750:
		self.free()
		caught = true
	if not caught:
		if first and $"..".scroll:
			if Global.skin == 0:
				$Butterfly.show()
				$Butterfly.position = first
			elif Global.skin == 1:
				$Carrot.show()
				$Carrot.position = first
			elif Global.skin == 2:
				$Acorn.show()
				$Acorn.position = first
			first = false
			
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
