extends Control
signal levelselected

func _on_level_pressed(level: String) -> void:
	emit_signal("levelselected", level)
	$levels.hide()
