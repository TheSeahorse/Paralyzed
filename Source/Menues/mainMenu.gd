extends Control


const LevelMenu = preload("res://Source/Menues/levelMenu.tscn")
var levelmenu
var can_change_key = false
var keybind_string #keybind being changed
var default_keybind_strings = ["cyan", "red", "purple", "yellow", "action", "escape", "flag", "remove", "sd"]
var default_keybinds = [KEY_Q, KEY_W, KEY_E, KEY_R, KEY_SPACE, KEY_ESCAPE, KEY_F, KEY_B, KEY_K]
enum keybinds {cyan, red, purple, yellow, action, escape, flag, remove, sd}


func _ready():
	$keybinds/separator/words.add_constant_override("separation", 11)
	$keybinds/separator.add_constant_override("separation", 6)
	$keybinds.add_constant_override("separation", 10)
	set_settings()
	set_keys()


func _input(event):
	if event is InputEventKey:
		if can_change_key:
			$press_key.hide()
			change_key(event, false)
			can_change_key = false


func _on_change_keybind_pressed(keybind: String) -> void:
	click_fx()
	mark_button(keybind)
	$press_key.show()


func _on_reset_default_pressed() -> void:
	click_fx()
	var counter = 0
	for key in default_keybinds:
		keybind_string = default_keybind_strings[counter]
		var event = InputEventKey.new()
		event.set_scancode(key)
		change_key(event, true)
		counter += 1
	set_keys()


func change_key(new_key: InputEvent, skip_set_keys: bool):
	#Delete key of pressed button
	if !InputMap.get_action_list(keybind_string).empty():
		InputMap.action_erase_event(keybind_string, InputMap.get_action_list(keybind_string)[0])


#Check if new key was assigned somewhere
	for i in keybinds:
		if InputMap.action_has_event(i, new_key):
			InputMap.action_erase_event(i, new_key)

	#Add new Key
	InputMap.action_add_event(keybind_string, new_key)
	if !skip_set_keys:
		set_keys()


func set_keys():
	for j in keybinds:
		get_node("keybinds/separator/buttons/" + str(j)).set_pressed(false)
		if !InputMap.get_action_list(j).empty():
			get_node("keybinds/separator/buttons/" + str(j) + "/Label").set_text(InputMap.get_action_list(j)[0].as_text())
		else:
			get_node("keybinds/separator/buttons/" + str(j) + "/Label").set_text("NaN!")


func set_settings():
	var settings = get_parent().SETTINGS
	$game/separator/buttons/hud.pressed = settings[0]
	$sound/separator/buttons/music.pressed = settings[1]
	$sound/separator/buttons/sfx.pressed = settings[2]
	$game/separator/buttons/fullscreen.pressed = settings[3]
	$game/separator/buttons/borderless.pressed = settings[4]
	$game/separator/buttons/white_background.pressed = settings[5]
	$game/separator/buttons/double_click_jump.pressed = settings[6]


func mark_button(string: String):
	can_change_key = true
	keybind_string = string
	for j in keybinds:
		if j != string:
			get_node("keybinds/separator/buttons/" + str(j)).set_pressed(false)


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


func show_credits():
	$back_credits.show()
	$gimp_logo.show()
	$godot_logo.show()
	$credits_background.show()
	$credits.show()


func hide_credits():
	$back_credits.hide()
	$gimp_logo.hide()
	$godot_logo.hide()
	$credits_background.hide()
	$credits.hide()


func show_keybinds():
	$back_keybinds.show()
	$keybinds.show()


func hide_keybinds():
	$back_keybinds.hide()
	$press_key.hide()
	can_change_key = false
	$keybinds.hide()


func show_game_settings():
	$back_game.show()
	$game.show()


func hide_game_settings():
	$back_game.hide()
	$game.hide()


func show_sound():
	$back_sound.show()
	$sound.show()


func hide_sound():
	$back_sound.hide()
	$sound.hide()



func show_level_menu():
	display_cleared_levels()
	levelmenu.show_level_menu()


# 0->1 | 1->2,5 | 2->3->4 | 5->6,9 | 6->7->8 | 9->10,13 | 10->11->12 | 13->14,17
# 14->15->16 | 2,6,10,14,17->18 | 3,7,11,15,18->19 | 4,8,12,16,19->20
func display_cleared_levels():
	var levels_cleared = get_parent().LEVELS_CLEARED
	levelmenu.enable_level(0) # should always be visible
	levelmenu.enable_level(1) # should always be visible
	var count = 0
	var all2 = 0 #takes five levels to unlock all 2 3 and 4 respectively
	var all3 = 0
	var all4 = 0
	for levels in levels_cleared:
		var cleared_normal = levels[0]
		var cleared_practice = levels[1]
		if cleared_normal:
			if count == 0:
				pass
			elif (count % 4 == 1) and (count < 17):
				levelmenu.enable_level(count + 1)
				levelmenu.enable_level(count + 4)
			elif (count % 4 != 0) and (count < 16):
				levelmenu.enable_level(count + 1)
			
			if (count == 2) or (count == 6) or (count == 10) or (count == 14) or (count == 17):
				all2 += 1
			elif (count == 3) or (count == 7) or (count == 11) or (count == 15) or (count == 18):
				all3 += 1
			elif (count == 4) or (count == 8) or (count == 12) or (count == 16) or (count == 19):
				all4 += 1
			
			if all2 == 5:
				levelmenu.enable_level(18)
			if all3 == 5:
				levelmenu.enable_level(19)
			if all4 == 5:
				levelmenu.enable_level(20)
			
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
	get_parent().save_game()
	get_tree().quit()



func _on_Settings_pressed() -> void:
	click_fx()
	hide_menu()
	$background.show()
	show_settings()


func _on_Credits_pressed() -> void:
	click_fx()
	hide_menu()
	show_credits()

func _on_Back_pressed(current: String) -> void:
	click_fx()
	match current:
		"settings":
			hide_settings()
			show_menu()
		"keybinds":
			hide_keybinds()
			show_settings()
		"game":
			hide_game_settings()
			show_settings()
		"sound":
			hide_sound()
			show_settings()
		"credits":
			hide_credits()
			show_menu()


func _on_Keybindings_pressed() -> void:
	click_fx()
	hide_settings()
	show_keybinds()


func _on_Sound_pressed() -> void:
	click_fx()
	hide_settings()
	show_sound()


func _on_Game_pressed() -> void:
	click_fx()
	hide_settings()
	show_game_settings()


func _on_CheckBox_toggled(button_pressed: bool, setting_nr: int) -> void:
	click_fx()
	get_parent().SETTINGS[setting_nr] = button_pressed
	match setting_nr:
		1:
			if button_pressed:
				start_music()
			else:
				stop_music()
		3:
			OS.window_fullscreen = button_pressed
			ProjectSettings.set_setting("display/window/size/fullscreen", button_pressed)
		4:
			OS.window_borderless = button_pressed
			ProjectSettings.set_setting("display/window/size/borderless", button_pressed)


func _on_link_pressed(link_name: String) -> void:
	click_fx()
	var error
	match link_name:
		"twitter":
			error = OS.shell_open("https://www.twitter.com/alexanderlahti")
		"youtube":
			error = OS.shell_open("https://www.youtube.com/kaatanglove")
		"linkedin":
			error = OS.shell_open("https://www.linkedin.com/in/alexander-lahti-1103801ab/")
		"spillana":
			error = OS.shell_open("https://www.fiverr.com/spillana")
		"teksoda":
			error = OS.shell_open("https://www.fiverr.com/teksoda")
		"godot":
			error = OS.shell_open("https://www.godotengine.org/")
		"gimp":
			error = OS.shell_open("https://www.gimp.org/")
		"empyrean":
			error = OS.shell_open("https://www.empyreanma.com/music-licensing")
	if error != OK:
		printerr("Couldn't open: \"%s\". Error code: %s." % [link_name, error])
