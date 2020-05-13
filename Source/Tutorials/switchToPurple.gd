extends CanvasLayer

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_released("purple"):
		get_tree().paused = false
		get_parent().player.is_color("purple")
		get_parent().level.play_animation("purple")
		self.queue_free()
