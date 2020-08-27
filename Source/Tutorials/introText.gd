extends CanvasLayer

func _ready() -> void:
	var intro_node = get_node_or_null("Sprite/intro_label")
	if intro_node != null:
		intro_node.set_text("press " + InputMap.get_action_list("action")[0].as_text() + " to continue")
	var recap_node = get_node_or_null("Sprite/recap_label")
	if recap_node != null:
		recap_node.set_text("Great!\n" + InputMap.get_action_list("cyan")[0].as_text() + " " + InputMap.get_action_list("red")[0].as_text() + " " + InputMap.get_action_list("purple")[0].as_text() + " " + InputMap.get_action_list("yellow")[0].as_text() + " and " + InputMap.get_action_list("action")[0].as_text() + "\nare the only buttons\nyou'll need to beat\nthis game. good luck!")


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_released("action"):
		get_tree().paused = false
		self.queue_free()
