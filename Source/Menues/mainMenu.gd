extends Control
const LevelTemplate = preload("res://Source/Menues/levelMenu.tscn")

var leveltemplate

func _on_Start_pressed() -> void:
	leveltemplate = LevelTemplate.instance()
	leveltemplate.connect("levelselected", self.get_parent(), "play_level")
	add_child(leveltemplate)
	$menu.hide()
