extends CanvasLayer

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_released("escape"):
		get_tree().paused = false
		get_parent().handle_pause(true)
		self.queue_free()
