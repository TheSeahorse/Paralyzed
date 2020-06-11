extends Control

var levelmenu


func hide_menu():
	$menu.hide()


func show_menu():
	$menu.show()


func show_level_menu():
	display_cleared_levels()
	levelmenu.show_menu()


func display_cleared_levels():
	var levels_cleared = get_parent().LEVELS_CLEARED
	var level_order = get_parent().LEVEL_ORDER
	for level in levels_cleared:
		var next_level = level_order[level_order.find(level) + 1]
		levelmenu.show_level(next_level)

func _on_Start_pressed() -> void:
	if !levelmenu:
		levelmenu = load("res://Source/Menues/levelMenu.tscn").instance()
		levelmenu.connect("levelselected", self.get_parent(), "play_level")
		add_child(levelmenu)
	display_cleared_levels()
	levelmenu.show_menu()
	$menu.hide()


func _on_Quit_pressed() -> void:
	get_tree().quit()
