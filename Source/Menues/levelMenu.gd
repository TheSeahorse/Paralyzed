extends Control
signal levelselected

func hide_menu():
	$all.hide()
	$go_back.hide()


func show_menu():
	$all.show()
	$go_back.show()


func _on_level_pressed(level: String) -> void:
	$click.play()
	emit_signal("levelselected", level)
	get_parent().get_parent().set_level_start_time()
	get_parent().stop_music()
	hide_menu()


func show_level(level: String):
	get_node("all/levels/" + level).show()


func show_checkbox(level: String):
	get_node("all/checkboxes/" + level).show()


func _on_goBack_pressed() -> void:
	$click.play()
	hide_menu()
	self.get_parent().show_menu()
