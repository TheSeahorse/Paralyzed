extends CanvasLayer
signal backMenu

func show_menu():
	$VBoxContainer.show()


func _on_continue_pressed() -> void:
	get_tree().paused = false
	$VBoxContainer.hide()


func _on_mainMenu_pressed() -> void:
	$VBoxContainer.hide()
	emit_signal("backMenu")
	get_tree().paused = false
