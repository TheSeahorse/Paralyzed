extends CanvasLayer


func _ready() -> void:
	$Sprite/Label.set_text("i forgot to mention\nthat you can pause\nat any time with\n" + InputMap.get_action_list("escape")[0].as_text() + ", try it!")


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("escape"):
		get_tree().paused = false
		get_parent().handle_pause(true)
		self.queue_free()
	if Input.is_action_just_released("escape"):
		get_parent().CAN_PAUSE = true
