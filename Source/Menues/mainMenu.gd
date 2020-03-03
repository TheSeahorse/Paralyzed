extends Control

var levelmenu


func hide_menu():
	$menu.hide()


func show_menu():
	$menu.show()


func show_level_menu():
	levelmenu.show_menu()


func _on_Start_pressed() -> void:
	levelmenu = load("res://Source/Menues/levelMenu.tscn").instance()
	levelmenu.connect("levelselected", self.get_parent(), "play_level")
	add_child(levelmenu)
	$menu.hide()
