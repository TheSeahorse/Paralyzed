extends CanvasLayer


func _ready() -> void:
	$Sprite/Label.set_text("to make an enemy \nsquare jump, press \n" + InputMap.get_action_list("action")[0].as_text() + " while being \nthe same          as it")


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_released("action"):
		get_tree().paused = false
		get_parent().player.SPRING_JUMP = 10
		get_parent().level.action(get_parent().player.PLAYER_COLOR)
		self.queue_free()
