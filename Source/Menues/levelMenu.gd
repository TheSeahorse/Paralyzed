extends Control
signal levelselected


func _ready() -> void:
	var level_node = get_node("ScrollContainer/levels")
	for n in level_node.get_children():
		n.add_constant_override("separation", 0)


func update_death_counts():
	var level_node = get_node("ScrollContainer/levels")
	var counter = 0
	for n in level_node.get_children():
		var death_node = get_node("ScrollContainer/levels/" + n.get_name() + "/TextureRect/deaths")
		if death_node != null:
			death_node.set_text(": " + str(get_parent().get_parent().DEATHS[counter]))
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
	var node = get_node("ScrollContainer/levels/" + level + "/TextureRect")
	var button_node = get_node("ScrollContainer/levels/" + level + "/TextureButton")
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


func enable_level(level: String):
	var node = get_node("ScrollContainer/levels/" + level + "/TextureButton")
	if node != null:
		node.set_disabled(false)


func _on_goBack_pressed() -> void:
	if get_parent().get_parent().SETTINGS[2]:
		$click.play()
	hide_level_menu()
	self.get_parent().show_menu()
