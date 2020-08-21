extends Control


const LevelMenu = preload("res://Source/Menues/levelMenu.tscn")
var levelmenu


func start_music():
	$menu_music.play(0.0)


func stop_music():
	$menu_music.stop()


func hide_menu():
	$background.hide()
	$menu.hide()
	$logo.hide()


func show_menu():
	$background.show()
	$menu.show()
	$logo.show()


func show_settings():
	$background.show()
	$settings.show()


func hide_settings():
	$settings.hide()


func show_level_menu():
	display_cleared_levels()
	levelmenu.show_menu()


func display_cleared_levels():
	var levels_cleared = get_parent().LEVELS_CLEARED
	var level_order = get_parent().LEVEL_ORDER
	for level in levels_cleared:
		if level_order.size() - 1 == levels_cleared.find(level):
			return
		else:
			var next_level = level_order[level_order.find(level) + 1]
			levelmenu.show_level(next_level)
		levelmenu.show_checkbox(level)


func _on_Start_pressed() -> void:
	if !levelmenu:
		levelmenu = LevelMenu.instance()
		levelmenu.connect("levelselected", self.get_parent(), "play_level")
		add_child(levelmenu)
	display_cleared_levels()
	levelmenu.show_menu()
	$click.play()
	hide_menu()


func _on_Quit_pressed() -> void:
	get_tree().quit()



func _on_Settings_pressed() -> void:
	hide_menu()
	show_settings()


func _on_Back_pressed() -> void:
	hide_settings()
	show_menu()


func setting_toggled(setting_nr: int):
	get_parent().SETTINGS[setting_nr] = !get_parent().SETTINGS[setting_nr]
