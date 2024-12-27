extends TextureRect

var pos
var lanes
@onready var short = preload("res://short_log.tscn")
@onready var long = preload("res://long_log.tscn")
@onready var collision = $River_Area/Collision
var logs = []
var next = []
var vel = []
var dir

func _ready() -> void:
	randomize()
	if global_position.y == 306:
		set_meta("lanes",3)
		size = Vector2(10000,3600)
		collision.shape.size = Vector2(10000,3600)
		collision.position = Vector2(5000,1800)
		lanes = 3
		pos = [600,1800,3000]
	else:
		var lanes_sel = randf()
		if lanes_sel <= 0.15:
			set_meta("lanes",2)
			size = Vector2(10000,2400)
			collision.shape.size = Vector2(10000,2400)
			collision.position = Vector2(5000,1200)
			lanes = 2
			pos = [600,1800]
		elif lanes_sel <= 0.4:
			set_meta("lanes",3)
			size = Vector2(10000,3600)
			collision.shape.size = Vector2(10000,3600)
			collision.position = Vector2(5000,1800)
			lanes = 3
			pos = [600,1800,3000]
		elif lanes_sel <= 0.7:
			set_meta("lanes",4)
			size = Vector2(10000,4800)
			collision.shape.size = Vector2(10000,4800)
			collision.position = Vector2(5000,2400)
			lanes = 4
			pos = [600,1800,3000,4200]
		elif lanes_sel <= 0.9:
			set_meta("lanes",5)
			size = Vector2(10000,6000)
			collision.shape.size = Vector2(10000,6000)
			collision.position = Vector2(5000,3000)
			lanes = 5
			pos = [600,1800,3000,4200,5400]
		else:
			set_meta("lanes",6)
			size = Vector2(10000,7200)
			collision.shape.size = Vector2(10000,7200)
			collision.position = Vector2(5000,3600)
			lanes = 6
			pos = [600,1800,3000,4200,5400,6600]
	
	for i in range(lanes):
		next.append(randf_range(0,1))
		vel.append(randf_range(1300,3000))
		logs.append([])
	dir = randi_range(0,1)
	

func _process(delta: float) -> void:
	for i in range(lanes):
		if next[i] <= 0:
			if randi_range(0,1):
				var new = short.instantiate()
				add_child(new)
				if dir != i%2:
					new.set_meta("velocity",-vel[i])
					new.position = Vector2(11000,pos[i])
					next[i] = randf_range(1,2.5)+1900/vel[i]
				else:
					new.set_meta("velocity",vel[i])
					new.position = Vector2(-1000,pos[i])
					next[i] = randf_range(1,2.5)+1900/vel[i]
				logs[i].append(new)
			else:
				var new = long.instantiate()
				add_child(new)
				if dir != i%2:
					new.set_meta("velocity",-vel[i])
					new.position = Vector2(11500,pos[i])
					next[i] = randf_range(1,2.5)+2800/vel[i]
				else:
					new.set_meta("velocity",vel[i])
					new.position = Vector2(-1500,pos[i])
					next[i] = randf_range(1,2.5)+2800/vel[i]
				logs[i].append(new)
	
		for log in logs[i]:
			if dir != i%2:
				log.position.x -= vel[i]*delta
				if log.position.x+50 < -(log.texture.get_width()*log.scale.x)/2:
					log.queue_free()
					logs[i].erase(log)
			else:
				log.position.x += vel[i]*delta
				if log.position.x-50 > 10000 + (log.texture.get_width()*log.scale.x)/2:
					log.queue_free()
					logs[i].erase(log)
		next[i] -= delta
	
	if global_position.y > 700:
		for i in get_children():
			i.free()
		self.free()
