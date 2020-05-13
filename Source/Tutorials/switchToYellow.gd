extends CanvasLayer

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_released("yellow"):
		get_tree().paused = false
		get_parent().player.is_color("yellow")
		get_parent().level.play_animation("yellow")
		self.queue_free()
