extends CanvasLayer
signal backMenu

var can_press_escape = false

func _input(event: InputEvent) -> void:
	if event.is_action_released("escape") and $VBoxContainer.visible:
		can_press_escape = true
	if event.is_action_pressed("escape") and can_press_escape:
		continue_game()

func show_menu():
	$pause.play()
	$VBoxContainer.show()


func _on_continue_pressed() -> void:
	$click.play()
	continue_game()


func continue_game():
	$unpause.play()
	get_tree().paused = false
	$VBoxContainer.hide()
	can_press_escape = false


func _on_mainMenu_pressed() -> void:
	$click.play()
	$VBoxContainer.hide()
	emit_signal("backMenu")
	get_tree().paused = false
	can_press_escape = false
