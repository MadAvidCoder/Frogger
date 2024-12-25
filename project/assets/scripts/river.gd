extends AnimatedSprite2D

var top = -1200
var middle = 0
var bottom = 1200
@onready var short = preload("res://short_log.tscn")
@onready var long = preload("res://long_log.tscn")
var top_logs = []
var middle_logs = []
var bottom_logs = []
var top_next
var middle_next
var bottom_next
var top_vel
var middle_vel
var bottom_vel
var dir

func _ready() -> void:
	randomize()
	top_next = randf_range(0,1)
	middle_next = randf_range(0,1)
	bottom_next = randf_range(0,1)
	top_vel = randf_range(1300,3000)
	middle_vel = randf_range(1300,3000)
	bottom_vel = randf_range(1300,3000)
	dir = randi_range(0,1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if top_next <= 0:
		if randi_range(0,1):
			var new = short.instantiate()
			add_child(new)
			if dir:
				new.set_meta("velocity",-top_vel)
				new.position = Vector2(5950,top)
				top_next = randf_range(1,2.5)+1900/top_vel
			else:
				new.set_meta("velocity",top_vel)
				new.position = Vector2(-5950,top)
				top_next = randf_range(1,2.5)+1900/top_vel
			top_logs.append(new)
		else:
			var new = long.instantiate()
			add_child(new)
			if dir:
				new.set_meta("velocity",-top_vel)
				new.position = Vector2(6400,top)
				top_next = randf_range(1,2.5)+2800/top_vel
			else:
				new.set_meta("velocity",top_vel)
				new.position = Vector2(-6400,top)
				top_next = randf_range(1,2.5)+2800/top_vel
			top_logs.append(new)
	if middle_next <= 0:
		if randi_range(0,1):
			var new = short.instantiate()
			add_child(new)
			if dir:
				new.set_meta("velocity",middle_vel)
				new.position = Vector2(-5950,middle)
				middle_next = randf_range(1,2.5)+1900/middle_vel
			else:
				new.set_meta("velocity",-middle_vel)
				new.position = Vector2(5950,middle)
				middle_next = randf_range(1,2.5)+1900/middle_vel
			middle_logs.append(new)
		else:
			var new = long.instantiate()
			new.set_meta("velocity",middle_vel)
			add_child(new)
			if dir:
				new.set_meta("velocity",middle_vel)
				new.position = Vector2(-6400,middle)
				middle_next = randf_range(1,2.5)+2800/middle_vel
			else:
				new.set_meta("velocity",-middle_vel)
				new.position = Vector2(6400,middle)
				middle_next = randf_range(1,2.5)+2800/middle_vel
			middle_logs.append(new)
	if bottom_next <= 0:
		if randi_range(0,1):
			var new = short.instantiate()
			add_child(new)
			if dir:
				new.set_meta("velocity",-bottom_vel)
				new.position = Vector2(5950,bottom)
				bottom_next = randf_range(1,2.5)+1900/bottom_vel
			else:
				new.set_meta("velocity",bottom_vel)
				new.position = Vector2(-5950,bottom)
				bottom_next = randf_range(1,2.5)+1900/bottom_vel
			bottom_logs.append(new)
		else:
			var new = long.instantiate()
			new.set_meta("velocity",bottom_vel)
			add_child(new)
			if dir:
				new.set_meta("velocity",-bottom_vel)
				new.position = Vector2(6400,bottom)
				bottom_next = randf_range(1,2.5)+2800/bottom_vel
			else:
				new.set_meta("velocity",bottom_vel)
				new.position = Vector2(-6400,bottom)
				bottom_next = randf_range(1,2.5)+2800/bottom_vel
			bottom_logs.append(new)
	
	for log in top_logs:
		if dir:
			log.position.x -= top_vel*delta
			if log.position.x < -5000 - (log.texture.get_width()*log.scale.x)/2:
				log.queue_free()
				top_logs.erase(log)
		else:
			log.position.x += top_vel*delta
			if log.position.x > 5000 + (log.texture.get_width()*log.scale.x)/2:
				log.queue_free()
				top_logs.erase(log)
	for log in middle_logs:
		if dir:
			log.position.x += middle_vel*delta
			if log.position.x < -5000 - (log.texture.get_width()*log.scale.x)/2:
				log.queue_free()
				middle_logs.erase(log)
		else:
			log.position.x -= middle_vel*delta
			if log.position.x > 5000 + (log.texture.get_width()*log.scale.x)/2:
				log.queue_free()
				middle_logs.erase(log)
	for log in bottom_logs:
		if dir:
			log.position.x -= bottom_vel*delta
			if log.position.x < -5000 - (log.texture.get_width()*log.scale.x)/2:
				log.queue_free()
				bottom_logs.erase(log)
		else:
			log.position.x += bottom_vel*delta
			if log.position.x > 5000 + (log.texture.get_width()*log.scale.x)/2:
				log.queue_free()
				bottom_logs.erase(log)
	
	top_next -= delta
	middle_next -= delta
	bottom_next -= delta
	
	if global_position.y > 750:
		for i in get_children():
			i.free()
		self.free()
