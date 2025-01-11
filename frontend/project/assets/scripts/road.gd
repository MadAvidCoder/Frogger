extends Sprite2D

var top = -104.501
var bottom = 104.501
var car_scenes = []
var top_cars = []
var bottom_cars = []
var top_next
var bottom_next
var top_vel
var bottom_vel
var dir

func _ready() -> void:
	car_scenes = [
		preload("res://assets/sprites/car/scenes/black_jeep.tscn"),
		preload("res://assets/sprites/car/scenes/black_luxury.tscn"),
		preload("res://assets/sprites/car/scenes/blue_coupe.tscn"),
		preload("res://assets/sprites/car/scenes/blue_hatch_back.tscn"),
		preload("res://assets/sprites/car/scenes/blue_sedan.tscn"),
		preload("res://assets/sprites/car/scenes/brown_hatch_back.tscn"),
		preload("res://assets/sprites/car/scenes/green_coupe.tscn"),
		preload("res://assets/sprites/car/scenes/green_wagon.tscn"),
		preload("res://assets/sprites/car/scenes/limo.tscn"),
		preload("res://assets/sprites/car/scenes/magenta_coupe.tscn"),
		preload("res://assets/sprites/car/scenes/magenta_supercar.tscn"),
		preload("res://assets/sprites/car/scenes/police.tscn"),
		preload("res://assets/sprites/car/scenes/red_civic.tscn"),
		preload("res://assets/sprites/car/scenes/red_hatch_back.tscn"),
		preload("res://assets/sprites/car/scenes/red_pickup.tscn"),
		preload("res://assets/sprites/car/scenes/taxi.tscn"),
		preload("res://assets/sprites/car/scenes/white_medium_truck.tscn"),
		preload("res://assets/sprites/car/scenes/white_suv.tscn"),
		preload("res://assets/sprites/car/scenes/yellow_bus.tscn"),
		preload("res://assets/sprites/car/scenes/yellow_suv.tscn")
	]
	randomize()
	top_next = randf_range(0,1)
	bottom_next = randf_range(0,1)
	top_vel = randf_range(300,600)
	bottom_vel = randf_range(300,600)
	dir = randi_range(0,1)

func _process(delta: float) -> void:
	if top_next <= 0:
		var new = car_scenes.pick_random().instantiate()
		add_child(new)
		new.z_index = 2
		if dir:
			new.flip_h = true
			new.position = Vector2(640+new.get_rect().size.x/2+50,top)
		else:
			new.position = Vector2(-640+new.get_rect().size.x/2-50,top)
		top_next = randf_range(0.7,3)+((new.get_rect().size.x*new.scale.x)/top_vel)
		top_cars.append(new)
	if bottom_next <= 0:
		var new = car_scenes.pick_random().instantiate()
		add_child(new)
		new.z_index = 3
		if dir:
			new.position = Vector2(-640+new.get_rect().size.x/2-50,bottom)
		else:
			new.flip_h = true
			new.position = Vector2(640+new.get_rect().size.x/2+50,bottom)
		bottom_next = randf_range(0.7,3)+((new.get_rect().size.x*new.scale.x)/bottom_vel)
		bottom_cars.append(new)
	for car in top_cars:
		if dir:
			car.position.x -= top_vel*delta
			if car.position.x < -1000:
				car.queue_free()
				top_cars.erase(car)
		else:
			car.position.x += top_vel*delta
			if car.position.x > 1000:
				car.queue_free()
				top_cars.erase(car)
	for car in bottom_cars:
		if dir:
			car.position.x += bottom_vel*delta
			if car.position.x > 1000:
				car.queue_free()
				bottom_cars.erase(car)
		else:
			car.position.x -= bottom_vel*delta
			if car.position.x < -1000:
				car.queue_free()
				bottom_cars.erase(car)
	top_next -= delta
	bottom_next -= delta
	
	if global_position.y > 750:
		for i in get_children():
			i.free()
		self.free()
