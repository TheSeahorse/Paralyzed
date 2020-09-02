extends Control
signal levelselected


var SHOWN_LEVEL: String = "" # the levelname which is currently shown


func _ready() -> void:
	var level_node = get_node("ScrollContainer/levels")
	for n in level_node.get_children():
		n.add_constant_override("separation", 0)


func update_death_counts():
	var level_node = get_node("ScrollContainer/levels")
	var counter = 0
	for n in level_node.get_children():
		var death_node = get_node("ScrollContainer/levels/" + n.get_name() + "/TextureRect/deaths")
		var death_practice_node = get_node("ScrollContainer/levels/" + n.get_name() + "/TextureRect/deaths_practice")
		var deaths_array = get_parent().get_parent().DEATHS[counter]
		if death_node != null:
			death_node.set_text(": " + str(deaths_array[0]))
		if death_practice_node != null:
			death_practice_node.set_text(": " + str(deaths_array[1]))
		counter += 1


func hide_level_menu():
	$background.hide()
	$ScrollContainer.hide()
	$go_back.hide()


func show_level_menu():
	$background.show()
	$ScrollContainer.show()
	$go_back.show()
	update_death_counts()


func _on_level_dropdown_pressed(level: String):
	if get_parent().get_parent().SETTINGS[2]:
		$click.play()
	if SHOWN_LEVEL == "":
		SHOWN_LEVEL = level
	elif SHOWN_LEVEL == level:
		SHOWN_LEVEL = ""
	else:
		var shown_node = get_node("ScrollContainer/levels/" + SHOWN_LEVEL + "/TextureRect")
		var shown_button_node = get_node("ScrollContainer/levels/" + SHOWN_LEVEL + "/TextureButton")
		toggle_button_node(shown_node, shown_button_node)
		SHOWN_LEVEL = level

	var node = get_node("ScrollContainer/levels/" + level + "/TextureRect")
	var button_node = get_node("ScrollContainer/levels/" + level + "/TextureButton")
	toggle_button_node(node, button_node)


func toggle_button_node(node: Node, button_node: Node):
	if node.visible:
		button_node.set_normal_texture(load("res://Character models/Menues/level_button_normal.png"))
		button_node.set_hover_texture(load("res://Character models/Menues/level_button_hover.png"))
		button_node.set_pressed_texture(load("res://Character models/Menues/level_button_pressed.png"))
		button_node.set_disabled_texture(load("res://Character models/Menues/level_button_disabled.png"))
		node.hide()
	else:
		button_node.set_normal_texture(load("res://Character models/Menues/level_button_normal_drop.png"))
		button_node.set_hover_texture(load("res://Character models/Menues/level_button_hover_drop.png"))
		button_node.set_pressed_texture(load("res://Character models/Menues/level_button_pressed_drop.png"))
		button_node.set_disabled_texture(load("res://Character models/Menues/level_button_disabled_drop.png"))
		node.show()


func _on_level_pressed(level: String, practice: bool) -> void:
	if get_parent().get_parent().SETTINGS[2]:
		$click.play()
	emit_signal("levelselected", level, practice)
	get_parent().get_parent().set_level_start_time()
	get_parent().stop_music()
	hide_level_menu()


# called in mainMenu
func enable_level(level: String):
	var node = get_node("ScrollContainer/levels/" + level + "/TextureButton")
	if node != null:
		node.set_disabled(false)


# called in mainMenu
func show_checkmarks(level_number: int, cleared_normal: bool, cleared_practice: bool):
	var container = get_node("ScrollContainer/levels")
	var levels = container.get_children()
	var level = levels[level_number]
	if cleared_normal:
		get_node("ScrollContainer/levels/" + level.get_name() + "/TextureRect/HBoxContainer/TextureButton2/checkmark").show()
	if cleared_practice:
		get_node("ScrollContainer/levels/" + level.get_name() + "/TextureRect/HBoxContainer/TextureButton/checkmark").show()

func _on_goBack_pressed() -> void:
	if get_parent().get_parent().SETTINGS[2]:
		$click.play()
	hide_level_menu()
	self.get_parent().show_menu()
