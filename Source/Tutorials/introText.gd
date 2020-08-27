extends CanvasLayer

func _ready() -> void:
	$Sprite/continue_label.set_text("press " + InputMap.get_action_list("action")[0].as_text() + " to continue")

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_released("action"):
		get_tree().paused = false
		self.queue_free()
