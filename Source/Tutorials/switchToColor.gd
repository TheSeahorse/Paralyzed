extends CanvasLayer

export var COLOR = "cyan"


func _ready() -> void:
	if COLOR == "red":
		red_text()
	elif COLOR == "purple":
		purple_text()
	elif COLOR == "yellow":
		yellow_text()
	elif COLOR == "cyan":
		cyan_text()


func red_text():
	$Sprite/Label.set_text("to change color \nto      ,\npress " + InputMap.get_action_list("red")[0].as_text())


func purple_text():
	$Sprite/Label.set_text("Good job!\nto change color \nto          ,\npress " + InputMap.get_action_list("purple")[0].as_text())


func yellow_text():
	$Sprite/Label.set_text("to change color \nto           ,\npress " + InputMap.get_action_list("yellow")[0].as_text())


func cyan_text():
	$Sprite/Label.set_text("and to go back \nto        ,\npress " + InputMap.get_action_list("cyan")[0].as_text())


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_released(COLOR):
		get_tree().paused = false
		get_parent().player.is_color(COLOR)
		get_parent().level.play_animation(COLOR)
		self.queue_free()
