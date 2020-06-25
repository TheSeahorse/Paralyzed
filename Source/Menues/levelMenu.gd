extends Control
signal levelselected

func hide_menu():
	$levels.hide()
	$go_back.hide()


func show_menu():
	$levels.show()
	$go_back.show()


func _on_level_pressed(level: String) -> void:
	emit_signal("levelselected", level)
	get_parent().get_parent().set_level_start_time()
	$levels.hide()
	$go_back.hide()


func show_level(level: String):
	get_node("levels/" + level).show()


func _on_goBack_pressed() -> void:
	$levels.hide()
	$go_back.hide()
	self.get_parent().show_menu()
