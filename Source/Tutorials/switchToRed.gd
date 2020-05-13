extends CanvasLayer

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_released("red"):
		get_tree().paused = false
		get_parent().player.is_color("red")
		get_parent().level.play_animation("red")
		self.queue_free()
