extends Control

var levelmenu


func hide_menu():
	$menu.hide()


func show_menu():
	$menu.show()


func show_level_menu():
	levelmenu.show_menu()


func levelmenu_show_level(level: String):
	levelmenu.show_level(level)


func _on_Start_pressed() -> void:
	if !levelmenu:
		levelmenu = load("res://Source/Menues/levelMenu.tscn").instance()
		levelmenu.connect("levelselected", self.get_parent(), "play_level")
		add_child(levelmenu)
	levelmenu.show_menu()
	$menu.hide()


func _on_Quit_pressed() -> void:
	get_tree().quit()
