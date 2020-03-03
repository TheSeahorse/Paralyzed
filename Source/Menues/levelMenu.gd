extends Control
signal levelselected

func hide_menu():
	$levels.hide()


func show_menu():
	$levels.show()


func _on_level_pressed(level: String) -> void:
	emit_signal("levelselected", level)
	$levels.hide()
