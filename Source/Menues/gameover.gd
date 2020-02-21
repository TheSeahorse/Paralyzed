extends Control
signal restartLevel
signal backMenu


func _on_restartLevel_pressed() -> void:
	emit_signal("restartLevel")


func _on_backMenu_pressed() -> void:
	emit_signal("backMenu")
