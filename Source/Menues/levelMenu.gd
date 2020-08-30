extends Control
signal levelselected

func hide_level_menu():
	$background.hide()
	$ScrollContainer.hide()
	$go_back.hide()


func show_level_menu():
	$background.show()
	$ScrollContainer.show()
	$go_back.show()


func _on_level_pressed(level: String, practice: bool) -> void:
	if get_parent().get_parent().SETTINGS[2]:
		$click.play()
	emit_signal("levelselected", level, practice)
	get_parent().get_parent().set_level_start_time()
	get_parent().stop_music()
	hide_level_menu()


func enable_level(level: String):
	get_node("ScrollContainer/levels/" + level).set_disabled(false)


func _on_goBack_pressed() -> void:
	if get_parent().get_parent().SETTINGS[2]:
		$click.play()
	hide_level_menu()
	self.get_parent().show_menu()
