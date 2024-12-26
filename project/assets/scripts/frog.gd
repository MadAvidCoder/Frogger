extends AnimatedSprite2D

signal scroll_screen(amount) 
var dir = ""
var vel = 0
var jump_vel = 60
@onready var area = $Frog_Area
var started = false
signal ended
@onready var score = $"../Score"
var score_num = 0

func _process(delta: float) -> void:
	if started:
		if Input.is_action_just_pressed("forward"):
			if "stationary" in animation:
				dir = "forward"
				play("forward_jump")
				vel = jump_vel
				score_num += 1
		elif Input.is_action_just_pressed("back"):
			if "stationary" in animation:
				dir = "back"
				play("back_jump")
				vel = jump_vel
				score_num -= 1
		elif Input.is_action_just_pressed("left"):
			if "stationary" in animation:
				dir = "left"
				play("left_jump")
				vel = jump_vel
		elif Input.is_action_just_pressed("right"):
			if "stationary" in animation:
				dir = "right"
				play("right_jump")
				vel = jump_vel
		if vel >= delta*200:
			if dir == "forward":
				position.y -= delta*200
				scroll_screen.emit(delta*100)
			elif dir == "back":
				position.y += delta*200
			elif dir == "left":
				position.x -= delta*200
			elif dir == "right":
				position.x += delta*200
			vel -= delta*200
		elif vel > 0:
			if dir == "forward":
				position.y -= vel
			elif dir == "back":
				position.y += vel
			elif dir == "left":
				position.x -= vel
			elif dir == "right":
				position.x += vel
			vel = 0
		var touching = area.get_overlapping_areas()
		if "River" in str(touching):
			if "Log" in str(touching):
				for i in touching:
					if "Log" in str(i) and animation != "dead":
						position.x += i.get_parent().get_meta("velocity")*delta*0.05
						
			else:
				if "stationary" in animation:
					dir = "dead"
					ended.emit()
					play("dead")
		elif "Car" in str(touching):
			if "stationary" in animation:
					dir = "dead"
					play("dead")
					ended.emit()
		
		if position.x <= 326:
			position.x = 326
		elif position.x >= 826:
			position.x = 826
		if global_position.y >= 700 and dir != "dead":
			dir = "dead"
			play("dead")
			ended.emit()
		elif global_position.y <= 500:
			scroll_screen.emit(delta*(500-global_position.y))
	
	if score_num > int(score.text):
		score.text = str(score_num)

func _on_animation_finished() -> void:
	if dir == "dead":
		play("dead")
		ended.emit()
		started = false
	else:
		play("%s_stationary" % dir)

func _on_started() -> void:
	started = true
