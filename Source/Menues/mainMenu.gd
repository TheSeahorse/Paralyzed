extends Control


const LevelMenu = preload("res://Source/Menues/levelMenu.tscn")
var levelmenu
var can_change_key = false
var keybind_string #keybind being changed
enum keybinds {cyan, red, purple, yellow, action, escape}


func _ready():
	set_keys()


func _input(event):
	if event is InputEventKey:
		if can_change_key:
			$press_key.hide()
			change_key(event)
			can_change_key = false


func change_key(new_key):
	#Delete key of pressed button
	if !InputMap.get_action_list(keybind_string).empty():
		InputMap.action_erase_event(keybind_string, InputMap.get_action_list(keybind_string)[0])

	#Check if new key was assigned somewhere
	for i in keybinds:
		if InputMap.action_has_event(i, new_key):
			InputMap.action_erase_event(i, new_key)

	#Add new Key
	InputMap.action_add_event(keybind_string, new_key)
	set_keys()


func set_keys():
	for j in keybinds:
		get_node("keybinds/" + str(j) + "/TextureButton").set_pressed(false)
		if !InputMap.get_action_list(j).empty():
			get_node("keybinds/" + str(j) + "/TextureButton/Label").set_text(InputMap.get_action_list(j)[0].as_text())
		else:
			get_node("keybinds/" + str(j) + "/TextureButton/Label").set_text("NaN!")


func mark_button(string: String):
	can_change_key = true
	keybind_string = string

	for j in keybinds:
		if j != string:
			get_node("keybinds/" + str(j) + "/TextureButton").set_pressed(false)


func click_fx():
	if get_parent().SETTINGS[2]:
		$click.play()


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
	$back_settings.show()
	$settings.show()


func hide_settings():
	$back_settings.hide()
	$settings.hide()


func show_keybinds():
	$back_keybinds.show()
	$keybinds.show()


func hide_keybinds():
	$back_keybinds.hide()
	$press_key.hide()
	can_change_key = false
	$keybinds.hide()


func show_level_menu():
	display_cleared_levels()
	levelmenu.show_level_menu()

# just nu visar den bara alla nivåer som är efter en nivå klarad i normal mode
func display_cleared_levels():
	var levels_cleared = get_parent().LEVELS_CLEARED
	var level_order = get_parent().LEVEL_ORDER
	var count = 0
	for levels in levels_cleared:
		var cleared_normal = levels[0]
		var cleared_practice = levels[1]
		if cleared_normal:
			if (count + 1) < level_order.size():
				levelmenu.enable_level(level_order[count + 1])
		levelmenu.show_checkmarks(count, cleared_normal, cleared_practice)
		count += 1


func _on_Start_pressed() -> void:
	if !levelmenu:
		levelmenu = LevelMenu.instance()
		levelmenu.connect("levelselected", self.get_parent(), "play_level")
		add_child(levelmenu)
	display_cleared_levels()
	levelmenu.show_level_menu()
	click_fx()
	hide_menu()


func _on_Quit_pressed() -> void:
	get_tree().quit()



func _on_Settings_pressed() -> void:
	click_fx()
	hide_menu()
	$background.show()
	show_settings()


func _on_Back_pressed() -> void:
	click_fx()
	hide_settings()
	show_menu()


func _on_Keybindings_pressed() -> void:
	click_fx()
	hide_settings()
	show_keybinds()


func _on_Back_keybinds_pressed() -> void:
	click_fx()
	hide_keybinds()
	show_settings()


func _on_change_keybind_pressed(keybind: String) -> void:
	click_fx()
	mark_button(keybind)
	$press_key.show()


func _on_CheckBox_toggled(button_pressed: bool, setting_nr: int) -> void:
	click_fx()
	get_parent().SETTINGS[setting_nr] = button_pressed
	if setting_nr == 1:
		if button_pressed:
			start_music()
		else:
			stop_music()
