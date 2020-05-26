extends CanvasLayer

export var COLOR = "cyan"

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_released(COLOR):
		get_tree().paused = false
		get_parent().player.is_color(COLOR)
		get_parent().level.play_animation(COLOR)
		self.queue_free()
