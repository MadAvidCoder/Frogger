extends AnimatedSprite2D

var dir = ""
var vel = 0
var jump_vel = 60

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("forward"):
		if "stationary" in animation:
			dir = "forward"
			play("forward_jump")
			vel = jump_vel
	elif Input.is_action_just_pressed("back"):
		if "stationary" in animation:
			dir = "back"
			play("back_jump")
			vel = jump_vel
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
	if vel > 0:
		if dir == "forward":
			position.y -= delta*180
		elif dir == "back":
			position.y += delta*180
		elif dir == "left":
			position.x -= delta*180
		elif dir == "right":
			position.x += delta*180
		vel -= delta*180

func _on_animation_finished() -> void:
	if dir == "dead":
		play("dead")
	else:
		play("%s_stationary" % dir)
