extends Control
const LevelMenu = preload("res://Source/Menues/levelMenu.tscn")

var levelmenu

func _on_Start_pressed() -> void:
	levelmenu = LevelMenu.instance()
	levelmenu.connect("levelselected", self.get_parent(), "play_level")
	add_child(levelmenu)
	$menu.hide()
