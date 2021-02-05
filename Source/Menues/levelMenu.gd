extends Control
signal levelselected


var SHOWN_LEVEL: String = "" # the levelname which is currently shown


func _ready() -> void:
	var level_node = get_node("levels")
	$stats/VBoxContainer.add_constant_override("separation", 2)
	$stats/VBoxContainer/deadliest_colors.add_constant_override("separation", 2)
	$stats/VBoxContainer/deadliest_enemies.add_constant_override("separation", 2)
	for group in level_node.get_children():
		for levels in group.get_children():
			levels.add_constant_override("separation", 0)


func hide_level_menu():
	self.hide()


func show_level_menu():
	self.show()
	update_stats()
	update_death_counts()
	update_tooltips()
	hide_current_level_and_stat()


func update_tooltips():
	var level_node = get_node("levels")
	for level_group in level_node.get_children():
		for level in level_group.get_children():
			var button_node = get_node("levels/" + level_group.get_name() + "/" + level.get_name() + "/TextureButton")
			var label_node = get_node("levels/" + level_group.get_name() + "/" + level.get_name() + "/TextureButton/Label")
			if button_node.is_disabled():
				label_node.set_mouse_filter(1)
			else:
				label_node.set_mouse_filter(2)


func update_death_counts():
	var level_node = get_node("levels")
	var counter = 1
	for level_group in level_node.get_children():
		for level in level_group.get_children():
			var death_node = get_node("levels/" + level_group.get_name() + "/" + level.get_name() + "/TextureRect/deaths")
			var death_practice_node = get_node("levels/" + level_group.get_name() + "/" + level.get_name() + "/TextureRect/deaths_practice")
			var deaths_array = get_parent().get_parent().DEATHS[counter]
			if death_node != null:
				if deaths_array[0] > 9999:
					death_node.set_text(": 9999")
				else:
					death_node.set_text(": " + str(deaths_array[0]))
			if death_practice_node != null:
				if deaths_array[1] > 9999:
					death_practice_node.set_text(": 9999")
				else:
					death_practice_node.set_text(": " + str(deaths_array[1]))
			counter += 1


# DEATHS: [[tutorial, tutorial_practice], [level1, level1_practice] .... ]
# DEATH_BY: [spikes, square, beam, lava, car, self-destruct]
# DEADLIEST_COLOR: [cyan, red, purple, yellow, none]
# STATS: [switched-color, square-jumped, car-jumped, phazed-beam, phazed-lava, placed-flag, paused]
# LEVELS_CLEARED: [[true, false], [false, true]] where [normal_level, practice_level]
func update_stats():
	var deaths = self.get_parent().get_parent().DEATHS
	var death_by = self.get_parent().get_parent().DEATH_BY
	var deadliest_color = self.get_parent().get_parent().DEADLIEST_COLOR
	var stats = self.get_parent().get_parent().STATS
	var levels_cleared = self.get_parent().get_parent().LEVELS_CLEARED
	var total_deaths = count_deaths(deaths)
	var hidden_stat = "??????????: 0"
	$stats/VBoxContainer/total_deaths.set_text("total deaths: " + str(total_deaths))
	$stats/VBoxContainer/deadliest_colors/cyan.set_text("cyan: " + str(deadliest_color[0]))
	$stats/VBoxContainer/deadliest_colors/red.set_text("red: " + str(deadliest_color[1]))
	$stats/VBoxContainer/deadliest_colors/purple.set_text("purple: " + str(deadliest_color[2]))
	$stats/VBoxContainer/deadliest_colors/yellow.set_text("yellow: " + str(deadliest_color[3]))
	$stats/VBoxContainer/deadliest_colors/none.set_text("no color: " + str(deadliest_color[4]))
	var best_color = calculate_deadliest_color(deadliest_color)
	var best_enemy = calculate_deadliest_enemy(death_by)
	var completion_percent = calculate_completion_percent(levels_cleared)
	$stats/VBoxContainer/deadliest_color.set_text("deadliest color: " + str(best_color))
	$stats/VBoxContainer/deadliest_enemy.set_text("deadliest enemy: " + str(best_enemy))
	$stats/VBoxContainer/completion.set_text("completion: " + str(completion_percent) + "%")
	if death_by[0] == 0:
		$stats/VBoxContainer/deadliest_enemies/spikes.set_text(hidden_stat)
	else:
		$stats/VBoxContainer/deadliest_enemies/spikes.set_text("spikes: " + str(death_by[0]))
	if death_by[1] == 0:
		$stats/VBoxContainer/deadliest_enemies/square.set_text(hidden_stat)
	else:
		$stats/VBoxContainer/deadliest_enemies/square.set_text("cube: " + str(death_by[1]))
	if death_by[2] == 0:
		$stats/VBoxContainer/deadliest_enemies/beam.set_text(hidden_stat)
	else:
		$stats/VBoxContainer/deadliest_enemies/beam.set_text("laser: " + str(death_by[2]))
	if death_by[3] == 0:
		$stats/VBoxContainer/deadliest_enemies/lava.set_text(hidden_stat)
	else:
		$stats/VBoxContainer/deadliest_enemies/lava.set_text("fire: " + str(death_by[3]))
	if death_by[4] == 0:
		$stats/VBoxContainer/deadliest_enemies/car.set_text(hidden_stat)
	else:
		$stats/VBoxContainer/deadliest_enemies/car.set_text("car: " + str(death_by[4]))
	if death_by[5] == 0:
		$stats/VBoxContainer/self_destructs.set_text(hidden_stat)
	else:
		$stats/VBoxContainer/self_destructs.set_text("self destructs: " + str(death_by[5]))
	if stats[0] == 0:
		$stats/VBoxContainer/changed_color.set_text(hidden_stat)
	else:
		$stats/VBoxContainer/changed_color.set_text("changed color " + str(stats[0]) + " times")
	if stats[1] == 0:
		$stats/VBoxContainer/square_jumps.set_text(hidden_stat)
	else:
		$stats/VBoxContainer/square_jumps.set_text("square jumps: " + str(stats[1]))
	if stats[2] == 0:
		$stats/VBoxContainer/car_jumps.set_text(hidden_stat)
	else:
		$stats/VBoxContainer/car_jumps.set_text("car jumps: " + str(stats[2]))
	if stats[3] == 0:
		$stats/VBoxContainer/phazed_laser.set_text(hidden_stat)
	else:
		$stats/VBoxContainer/phazed_laser.set_text("lasers phazed: " + str(stats[3]))
	if stats[4] == 0:
		$stats/VBoxContainer/survived_lava.set_text(hidden_stat)
	else:
		$stats/VBoxContainer/survived_lava.set_text("fires survived: " + str(int(stats[4] / 2)))
	if stats[5] == 0:
		$stats/VBoxContainer/placed_flags.set_text(hidden_stat)
	else:
		$stats/VBoxContainer/placed_flags.set_text("practice flags placed: " + str(stats[5]))
	if stats[6] == 0:
		$stats/VBoxContainer/paused.set_text(hidden_stat)
	else:
		$stats/VBoxContainer/paused.set_text("times paused: " + str(stats[6]))
	if stats[7] == 0:
		$stats/VBoxContainer/goals_reached.set_text(hidden_stat)
	else:
		$stats/VBoxContainer/goals_reached.set_text("goals reached: " + str(stats[7]))
	if stats[8] == 0:
		$stats/VBoxContainer/square_deaths.set_text(hidden_stat)
	else:
		$stats/VBoxContainer/square_deaths.set_text("squares exploded: " + str(stats[8]))
	if stats[9] == 0:
		$stats/VBoxContainer/car_deaths.set_text(hidden_stat)
	else:
		$stats/VBoxContainer/car_deaths.set_text("cars exploded: " + str(stats[9]))
	if stats[10] == 0:
		$stats/VBoxContainer/endless_runs.set_text(hidden_stat)
	else:
		$stats/VBoxContainer/endless_runs.set_text("endless attempts: " + str(stats[10]))
	if stats[11] == 0:
		$stats/VBoxContainer/endless_high_score.set_text(hidden_stat)
	else:
		$stats/VBoxContainer/endless_high_score.set_text("endless high score: " + str(stats[11]))


func count_deaths(deaths: Array) -> int:
	var amount = 0
	for d in deaths:
		amount += d[0]
		amount += d[1]
	return amount


# if practice completed, half points, otherwise full points
# tutorial is worth 0.4
# cu-1, l-1, f-1, ca-1 is worth 1.0
# cu-2, l-2, f-2, ca-2 is worth 1.2
# cu-3, l-3, f-3, ca-3, all-1 is worth 1.6
# cu-4, l-3, f-4, ca-4, all-2 is worth 2
# all-3 is worth 2.4
# final is worth 3
func calculate_completion_percent(levels_cleared: Array) -> int:
	var counter = 0
	var total_points = 0.0
	var cleared_points = 0.0
	for level in levels_cleared:
		var full_points
		match counter:
			0:
				full_points = 0.5
			1, 5, 9, 13:
				full_points = 1.0
			2, 6, 10, 14:
				full_points = 1.2
			3, 7, 11, 15, 17:
				full_points = 1.4
			4, 8, 12, 16, 18:
				full_points = 1.8
			19:
				full_points = 2.0
			20:
				full_points = 2.5
		if level[0]:
			cleared_points += full_points
		elif level[1]:
			cleared_points += full_points/2.0
		total_points += full_points
		counter += 1
	var percent = float(cleared_points)/float(total_points)*100.0
	var dynamic_font = $stats/VBoxContainer/completion.get("custom_colors/font_outline_modulate")
	if percent < 20.0:
		dynamic_font = Color.red
	elif percent < 40.0:
		dynamic_font = Color.orange
	elif percent < 60.0:
		dynamic_font = Color.yellow
	elif percent < 80.0:
		dynamic_font = Color.lime
	elif percent < 100.0:
		dynamic_font = Color.green
	else:
		dynamic_font = Color.blue
	$stats/VBoxContainer/completion.set("custom_colors/font_outline_modulate", dynamic_font)
	return int(percent)

# no color gills inte, därför så komplicerad funktion
func calculate_deadliest_color(stats: Array) -> String:
	var deadliest: String
	var highest_count = 0
	for s in stats:
		if s > highest_count:
			if (s != stats[4]) or (stats.count(s) != 1):
				highest_count = s
	if highest_count == 0:
		return "none"
	var index = stats.find(highest_count)
	match index:
		0:
			deadliest = "cyan"
		1:
			deadliest = "red"
		2:
			deadliest = "purple"
		3:
			deadliest = "yellow"
		_:
			deadliest = "none"
	return deadliest


# [spikes, square, beam, lava, car, self-destruct]
# self destruct räknas inte, därför complex
func calculate_deadliest_enemy(stats: Array) -> String:
	var deadliest: String
	var highest_count = 0
	for s in stats:
		if s > highest_count:
			if (s != stats[5]) or (stats.count(s) != 1):
				highest_count = s
	if highest_count == 0:
		return "none"
	var index = stats.find(highest_count)
	match index:
		0:
			deadliest = "spikes"
		1:
			deadliest = "cube"
		2:
			deadliest = "laser"
		3:
			deadliest = "fire"
		4:
			deadliest = "car"
		_:
			deadliest = "none"
	return deadliest


func hide_current_level_and_stat():
	if SHOWN_LEVEL != "":
		toggle_button_node(SHOWN_LEVEL)
		SHOWN_LEVEL = ""
	$stats/VBoxContainer/deadliest_colors.hide()
	$stats/VBoxContainer/deadliest_enemies.hide()


func toggle_button_node(level_name: String):
	var node
	var button_node
	match level_name:
		"tutorial":
			# TODO
			pass
		"level1", "level2", "level3", "level4":
			node = get_node("levels/cube/" + level_name + "/TextureRect")
			button_node = get_node("levels/cube/" + level_name + "/TextureButton")
		"level5", "level6", "level7", "level8":
			node = get_node("levels/laser/" + level_name + "/TextureRect")
			button_node = get_node("levels/laser/" + level_name + "/TextureButton")
		"level9", "level10", "level11", "level12":
			node = get_node("levels/fire/" + level_name + "/TextureRect")
			button_node = get_node("levels/fire/" + level_name + "/TextureButton")
		"level13", "level14", "level15", "level16":
			node = get_node("levels/car/" + level_name + "/TextureRect")
			button_node = get_node("levels/car/" + level_name + "/TextureButton")
		"level17", "level18", "level19", "level20":
			node = get_node("levels/all/" + level_name + "/TextureRect")
			button_node = get_node("levels/all/" + level_name + "/TextureButton")
	if node.visible:
		button_node.set_normal_texture(load("res://Character models/Menues/LevelMenu/level_button_normal.png"))
		button_node.set_hover_texture(load("res://Character models/Menues/LevelMenu/level_button_hover.png"))
		button_node.set_pressed_texture(load("res://Character models/Menues/LevelMenu/level_button_pressed.png"))
		node.hide()
	else:
		button_node.set_normal_texture(load("res://Character models/Menues/LevelMenu/level_button_normal_drop.png"))
		button_node.set_hover_texture(load("res://Character models/Menues/LevelMenu/level_button_hover_drop.png"))
		button_node.set_pressed_texture(load("res://Character models/Menues/LevelMenu/level_button_pressed_drop.png"))
		node.show()


# called in mainMenu
func enable_level(level: int):
	var node
	match level:
		0:
			node = get_node("tutorials/practice")
		1,2,3,4:
			node = get_node("levels/cube/level" + str(level) + "/TextureButton")
		5,6,7,8:
			node = get_node("levels/laser/level" + str(level) + "/TextureButton")
		9,10,11,12:
			node = get_node("levels/fire/level" + str(level) + "/TextureButton")
		13,14,15,16:
			node = get_node("levels/car/level" + str(level) + "/TextureButton")
		17,18,19,20:
			node = get_node("levels/all/level" + str(level) + "/TextureButton")
	if node != null:
		node.set_disabled(false)


# called in mainMenu
func show_checkmarks(level_number: int, cleared_normal: bool, cleared_practice: bool):
	var level_name = "level" + str(level_number)
	var level_mark
	var start_mark
	var practice_mark
	match level_number:
		0:
			level_mark = get_node("tutorials/normal/checkmark")
			start_mark = get_node("tutorials/normal/checkmark") #there is none for tutorial
			practice_mark = get_node("tutorials/practice/checkmark")
		1,2,3,4:
			level_mark = get_node("levels/cube/" + level_name + "/TextureButton/checkmark")
			start_mark = get_node("levels/cube/" + level_name + "/TextureRect/HBoxContainer/TextureButton2/checkmark")
			practice_mark = get_node("levels/cube/" + level_name + "/TextureRect/HBoxContainer/TextureButton/checkmark")
		5,6,7,8:
			level_mark = get_node("levels/laser/" + level_name + "/TextureButton/checkmark")
			start_mark = get_node("levels/laser/" + level_name + "/TextureRect/HBoxContainer/TextureButton2/checkmark")
			practice_mark = get_node("levels/laser/" + level_name + "/TextureRect/HBoxContainer/TextureButton/checkmark")
		9,10,11,12:
			level_mark = get_node("levels/fire/" + level_name + "/TextureButton/checkmark")
			start_mark = get_node("levels/fire/" + level_name + "/TextureRect/HBoxContainer/TextureButton2/checkmark")
			practice_mark = get_node("levels/fire/" + level_name + "/TextureRect/HBoxContainer/TextureButton/checkmark")
		13,14,15,16:
			level_mark = get_node("levels/car/" + level_name + "/TextureButton/checkmark")
			start_mark = get_node("levels/car/" + level_name + "/TextureRect/HBoxContainer/TextureButton2/checkmark")
			practice_mark = get_node("levels/car/" + level_name + "/TextureRect/HBoxContainer/TextureButton/checkmark")
		17,18,19,20:
			level_mark = get_node("levels/all/" + level_name + "/TextureButton/checkmark")
			start_mark = get_node("levels/all/" + level_name + "/TextureRect/HBoxContainer/TextureButton2/checkmark")
			practice_mark = get_node("levels/all/" + level_name + "/TextureRect/HBoxContainer/TextureButton/checkmark")
	if cleared_normal:
		level_mark.show()
		start_mark.show()
	if cleared_practice:
		practice_mark.show()


func reset_stat_buttons():
	$stats/VBoxContainer/deadliest_color/Button/arrow.set_rotation(0)
	$stats/VBoxContainer/deadliest_enemy/Button/arrow.set_rotation(0)


func _on_level_dropdown_pressed(level: String):
	if get_parent().get_parent().SETTINGS[2]:
		$click.play()
	if SHOWN_LEVEL == "":
		SHOWN_LEVEL = level
	elif SHOWN_LEVEL == level:
		SHOWN_LEVEL = ""
	else:
		toggle_button_node(SHOWN_LEVEL)
		SHOWN_LEVEL = level
	toggle_button_node(level)


func _on_level_pressed(level: String, practice: bool) -> void:
	if get_parent().get_parent().SETTINGS[2]:
		$click.play()
	emit_signal("levelselected", level, practice)
	get_parent().get_parent().set_level_start_time()
	get_parent().stop_music()
	reset_stat_buttons()
	hide_level_menu()


func _on_goBack_pressed() -> void:
	if get_parent().get_parent().SETTINGS[2]:
		$click.play()
	hide_level_menu()
	self.get_parent().show_menu()
	reset_stat_buttons()


func _on_stats_button_pressed(type: String) -> void:
	if get_parent().get_parent().SETTINGS[2]:
		$click.play()
	match type:
		"color":
			if $stats/VBoxContainer/deadliest_colors.visible:
				$stats/VBoxContainer/deadliest_colors.hide()
				$stats/VBoxContainer/deadliest_color/Button/arrow.set_rotation(0)
			else:
				$stats/VBoxContainer/deadliest_enemies.hide()
				$stats/VBoxContainer/deadliest_enemy/Button/arrow.set_rotation(0)
				$stats/VBoxContainer/deadliest_colors.show()
				$stats/VBoxContainer/deadliest_color/Button/arrow.set_rotation(PI)
		"enemy":
			if $stats/VBoxContainer/deadliest_enemies.visible:
				$stats/VBoxContainer/deadliest_enemies.hide()
				$stats/VBoxContainer/deadliest_enemy/Button/arrow.set_rotation(0)
			else:
				$stats/VBoxContainer/deadliest_colors.hide()
				$stats/VBoxContainer/deadliest_color/Button/arrow.set_rotation(0)
				$stats/VBoxContainer/deadliest_enemies.show()
				$stats/VBoxContainer/deadliest_enemy/Button/arrow.set_rotation(PI)


func _on_leaderboard_pressed():
	if get_parent().get_parent().SETTINGS[2]:
		$click.play()
	get_parent().get_parent().show_leaderboard()
	reset_stat_buttons()
	hide_level_menu()
