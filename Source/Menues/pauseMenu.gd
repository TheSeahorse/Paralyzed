extends CanvasLayer
signal backMenu

var can_press_escape = false

func _input(event: InputEvent) -> void:
	if event.is_action_released("escape") and $VBoxContainer.visible:
		can_press_escape = true
	if event.is_action_pressed("escape") and can_press_escape:
		continue_game()

func show_menu():
	if get_parent().SETTINGS[2]:
		$pause.play()
	$VBoxContainer.show()


func _on_continue_pressed() -> void:
	if get_parent().SETTINGS[2]:
		$click.play()
	continue_game()


func continue_game():
	if get_parent().SETTINGS[2]:
		$unpause.play()
	get_tree().paused = false
	$VBoxContainer.hide()
	can_press_escape = false


func _on_mainMenu_pressed() -> void:
	if get_parent().SETTINGS[2]:
		$click.play()
	$VBoxContainer.hide()
	emit_signal("backMenu")
	get_tree().paused = false
	can_press_escape = false
