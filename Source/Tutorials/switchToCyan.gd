extends CanvasLayer

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_released("cyan"):
		get_tree().paused = false
		get_parent().player.is_color("cyan")
		get_parent().level.play_animation("cyan")
		self.queue_free()
