extends CanvasLayer
signal restartLevel
signal backMenu


func show_menu():
	$VBoxContainer.show()


func _on_restartLevel_pressed() -> void:
	$VBoxContainer.hide()
	emit_signal("restartLevel")


func _on_backMenu_pressed() -> void:
	$VBoxContainer.hide()
	emit_signal("backMenu")
