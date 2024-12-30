extends Node2D

var top: float = -114.034
var next: float = 0
signal started(character)
var scroll: bool = false
var begun: bool = false
var needs_grass: bool = false
var restart = false
var waiting = false

@onready var grass = preload("res://grass.tscn")
@onready var river = preload("res://river.tscn")
@onready var road = preload("res://road.tscn")
@onready var big_road = preload("res://big_road.tscn")
@onready var short_log = preload("res://short_log.tscn")
@onready var long_log = preload("res://long_log.tscn")

func _ready() -> void:
	$End.hide()
	$Start.show()
	$Start/Arrow_Left.hide()
	$Start/Arrow_Right.hide()
	if Global.skin == 0:
		get_tree().call_group("Frog", "show")
		get_tree().call_group("Rabbit", "hide")
		get_tree().call_group("Squirrel", "hide")
	elif Global.skin == 1:
		get_tree().call_group("Frog", "hide")
		get_tree().call_group("Rabbit", "show")
		get_tree().call_group("Squirrel", "hide")
	elif Global.skin == 2:
		get_tree().call_group("Frog", "hide")
		get_tree().call_group("Rabbit", "hide")
		get_tree().call_group("Squirrel", "show")
	if Global.user != "":
		$Start/Button.text = "Play Game"
		$Start/Arrow_Left.show()
		$Start/Arrow_Right.show()
		$Start/Username.text = Global.user
		$Start/Coins.text = str(Global.coins)
		$High_Score.text = str(Global.high_score)

func _process(delta: float) -> void:
	if scroll:
		if next <= 0:
			var selected = randi_range(0,2)
			if selected == 0 or needs_grass:
				needs_grass = false
				var new = grass.instantiate()
				add_child(new)
				new.position = Vector2(576,top-60)
				top -= 120
				next = 120
			elif selected == 1:
				needs_grass = true
				var new = river.instantiate()
				add_child(new)
				var size = new.get_meta("lanes")*60
				new.position = Vector2(326,top-size)
				top -= size
				next = size
			else:
				if randi_range(0,1):
					needs_grass = true
					var new = road.instantiate()
					add_child(new)
					new.position = Vector2(576,top-90)
					top -= 180
					next = 180
				else:
					needs_grass = true
					var new = big_road.instantiate()
					add_child(new)
					new.position = Vector2(576,top-180)
					top -= 360
					next = 360
		position.y += delta*30
		next -= delta*30
		
	if not begun and not $Loading.visible:
		if Input.is_action_just_pressed("start"):
			_start_game()
		elif Input.is_action_just_pressed("right") and Global.user != "":
			_on_arrow_right_pressed()
		elif Input.is_action_just_pressed("left") and Global.user != "":
			_on_arrow_left_pressed()
	elif $End.visible == true and Input.is_action_just_pressed("start"):
		_restart_game()

func _scroll_screen(amount: Variant) -> void:
	if scroll:
		position.y += amount
		next -= amount

func _start_game() -> void:
	if not $Loading.visible:
		if Global.user == "":
			$Signin.show()
			$Start.hide()
		elif $Signin.visible:
			pass
		else:
			if $Start/Button.text == "Play Game":
				begun = true
				$Start.hide()
				$End.hide()
				if Global.skin == 0:
					started.emit("frog")
					get_tree().call_group("Frog", "show")
					get_tree().call_group("Rabbit", "hide")
					get_tree().call_group("Squirrel", "hide")
				elif Global.skin == 1:
					started.emit("rabbit")
					get_tree().call_group("Frog", "hide")
					get_tree().call_group("Rabbit", "show")
					get_tree().call_group("Squirrel", "hide")
				elif Global.skin == 2:
					started.emit("squirrel")
					get_tree().call_group("Frog", "hide")
					get_tree().call_group("Rabbit", "hide")
					get_tree().call_group("Squirrel", "show")
				scroll = true
				$Start.queue_free()
			else:
				if not $Start/Button.disabled:
					$Loading.show()
					$Loading/Circle.play()
					if Global.skin == 1:
						Global.coins -= 500
						Global.skins.append("rabbit")
						await Global.edit_user(Global.user, "coins", Global.coins)
						await Global.edit_user(Global.user, "skins", ",".join(Global.skins))
					elif Global.skin == 2:
						Global.coins -= 1000
						Global.skins.append("squirrel")
						await Global.edit_user(Global.user, "coins", Global.coins)
						await Global.edit_user(Global.user, "skins", ",".join(Global.skins))
					$Start/Button.disabled = false
					$Start/Coins.text = str(Global.coins)
					$Start/Button.text = "Play Game"
					$Loading.hide()
					$Loading/Circle.stop()

func _on_frog_ended() -> void:
	$Timer.start()

func _on_timer_timeout() -> void:
	$End.show()
	scroll = false
	if int($Score.text) > int($High_Score.text):
		$High_Score.text = $Score.text
		await Global.edit_user(Global.user, "high_score", $High_Score.text)
		Global.high_score = int($High_Score.text)
	Global.coins += int($Score.text)
	await Global.edit_user(Global.user, "coins", Global.coins)
	restart = true
	if waiting: _restart_game()

func _restart_game() -> void:
	if restart:
		get_tree().reload_current_scene()
	else:
		waiting = true
		$Loading.show()
		$Loading/Circle.play()

func _on_arrow_left_pressed() -> void:
	if not $Loading.visible:
		Global.skin -= 1
		if Global.skin == -1:
			Global.skin = 2
		if Global.skin == 0:
			get_tree().call_group("Frog", "show")
			get_tree().call_group("Rabbit", "hide")
			get_tree().call_group("Squirrel", "hide")
			$Start/Button.text = "Play Game"
			$Start/Button.disabled = false
		elif Global.skin == 1:
			get_tree().call_group("Frog", "hide")
			get_tree().call_group("Rabbit", "show")
			get_tree().call_group("Squirrel", "hide")
			if "rabbit" in Global.skins:
				$Start/Button.text = "Play Game"
				$Start/Button.disabled = false
			else:
				$Start/Button.text = "500 Coins"
				if Global.coins < 500:
					$Start/Button.disabled = true
				else:
					$Start/Button.disabled = false
		elif Global.skin == 2:
			get_tree().call_group("Frog", "hide")
			get_tree().call_group("Rabbit", "hide")
			get_tree().call_group("Squirrel", "show")
			if "squirrel" in Global.skins:
				$Start/Button.text = "Play Game"
				$Start/Button.disabled = false
			else:
				$Start/Button.text = "1000 Coins"
				if Global.coins < 1000:
					$Start/Button.disabled = true
				else:
					$Start/Button.disabled = false

func _on_arrow_right_pressed() -> void:
	if not $Loading.visible:
		Global.skin += 1
		if Global.skin == 3:
			Global.skin = 0
		if Global.skin == 0:
			get_tree().call_group("Frog", "show")
			get_tree().call_group("Rabbit", "hide")
			get_tree().call_group("Squirrel", "hide")
			$Start/Button.text = "Play Game"
			$Start/Button.disabled = false
		elif Global.skin == 1:
			get_tree().call_group("Frog", "hide")
			get_tree().call_group("Rabbit", "show")
			get_tree().call_group("Squirrel", "hide")
			if "rabbit" in Global.skins:
				$Start/Button.text = "Play Game"
				$Start/Button.disabled = false
			else:
				$Start/Button.text = "500 Coins"
				if Global.coins < 500:
					$Start/Button.disabled = true
				else:
					$Start/Button.disabled = false
		elif Global.skin == 2:
			get_tree().call_group("Frog", "hide")
			get_tree().call_group("Rabbit", "hide")
			get_tree().call_group("Squirrel", "show")
			if "squirrel" in Global.skins:
				$Start/Button.text = "Play Game"
				$Start/Button.disabled = false
			else:
				$Start/Button.text = "1000 Coins"
				if Global.coins < 1000:
					$Start/Button.disabled = true
				else:
					$Start/Button.disabled = false

func _on_signin_authenticated() -> void:
	$Start/Arrow_Left.show()
	$Start/Arrow_Right.show()
	$Start/Button.text = "Play Game"
	Global.skins = await Global.get_user_info(Global.user, "skins")
	if Global.skins != "":
		Global.skins = Global.skins.split(",")
	else:
		Global.skins = []
	Global.coins = int(await Global.get_user_info(Global.user, "coins"))
	Global.high_score = int(await Global.get_user_info(Global.user, "high_score"))
	$Start/Coins.text = str(Global.coins) + " Coins"
	$Start/Username.text = Global.user
	$High_Score.text = str(Global.high_score)
	$Start.show()
	$Signin.hide()
	$Signin._on_has_account_button_pressed()
	$Loading.hide()
	$Loading/Circle.stop()
