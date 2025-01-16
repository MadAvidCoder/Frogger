extends AnimatedSprite2D

func _on_rotten_log_area_area_entered(area: Area2D) -> void:
	if "Frog" in area.name or "Rabbit" in area.name or "Squirrel" in area.name:
		play()
		await get_tree().create_timer(1).timeout
		hide()
		set_meta("gone", true)
