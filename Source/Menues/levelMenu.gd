extends Control
signal levelselected


var SHOWN_LEVEL: String = "" # the levelname which is currently shown


func _ready() -> void:
	var level_node = get_node("ScrollContainer/levels")
	$stats/VBoxContainer.add_constant_override("separation", 3)
	for n in level_node.get_children():
		n.add_constant_override("separation", 0)


func hide_level_menu():
	self.hide()


func show_level_menu():
	self.show()
	update_stats()
	update_death_counts()
	update_tooltips()
	hide_current_level_and_stat()


func update_tooltips():
	var level_node = get_node("ScrollContainer/levels")
	for n in level_node.get_children():
		var button_node = get_node("ScrollContainer/levels/" + n.get_name() + "/TextureButton")
		var label_node = get_node("ScrollContainer/levels/" + n.get_name() + "/TextureButton/Label")
		if button_node.is_disabled():
			label_node.set_mouse_filter(1)
		else:
			label_node.set_mouse_filter(2)



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


# DEATHS: [[tutorial, tutorial_practice], [level1, level1_practice] .... ]
# DEATH_BY: [spikes, square, beam, lava, car, self-destruct]
# DEADLIEST_COLOR: [cyan, red, purple, yellow, none]
# STATS: [switched-color, square-jumped, car-jumped, phazed-beam, phazed-lava, placed-flag, paused]
func update_stats():
	var deaths = self.get_parent().get_parent().DEATHS
	var death_by = self.get_parent().get_parent().DEATH_BY
	var deadliest_color = self.get_parent().get_parent().DEADLIEST_COLOR
	var stats = self.get_parent().get_parent().STATS
	var total_deaths = count_deaths(deaths)
	$stats/VBoxContainer/total_deaths.set_text("total deaths: " + str(total_deaths))
	$stats/VBoxContainer/deadliest_colors/cyan.set_text("cyan: " + str(deadliest_color[0]))
	$stats/VBoxContainer/deadliest_colors/red.set_text("red: " + str(deadliest_color[1]))
	$stats/VBoxContainer/deadliest_colors/purple.set_text("purple: " + str(deadliest_color[2]))
	$stats/VBoxContainer/deadliest_colors/yellow.set_text("yellow: " + str(deadliest_color[3]))
	$stats/VBoxContainer/deadliest_colors/none.set_text("no color: " + str(deadliest_color[4]))
	var best_color = calculate_deadliest_color(deadliest_color)
	var best_enemy = calculate_deadliest_enemy(death_by)
	$stats/VBoxContainer/deadliest_color.set_text("deadliest color: " + str(best_color))
	$stats/VBoxContainer/deadliest_enemy.set_text("deadliest enemy: " + str(best_enemy))
	if death_by[0] == 0:
		$stats/VBoxContainer/deadliest_enemies/spikes.set_text("nan")
	else:
		$stats/VBoxContainer/deadliest_enemies/spikes.set_text("spikes: " + str(death_by[0]))
	if death_by[1] == 0:
		$stats/VBoxContainer/deadliest_enemies/square.set_text("nan")
	else:
		$stats/VBoxContainer/deadliest_enemies/square.set_text("square: " + str(death_by[1]))
	if death_by[2] == 0:
		$stats/VBoxContainer/deadliest_enemies/beam.set_text("nan")
	else:
		$stats/VBoxContainer/deadliest_enemies/beam.set_text("laser: " + str(death_by[2]))
	if death_by[3] == 0:
		$stats/VBoxContainer/deadliest_enemies/lava.set_text("nan")
	else:
		$stats/VBoxContainer/deadliest_enemies/lava.set_text("fire: " + str(death_by[3]))
	if death_by[4] == 0:
		$stats/VBoxContainer/deadliest_enemies/car.set_text("nan")
	else:
		$stats/VBoxContainer/deadliest_enemies/car.set_text("car: " + str(death_by[4]))
	if death_by[5] == 0:
		$stats/VBoxContainer/self_destructs.set_text("nan")
	else:
		$stats/VBoxContainer/self_destructs.set_text("self destructs: " + str(death_by[5]))
	if stats[0] == 0:
		$stats/VBoxContainer/changed_color.set_text("nan")
	else:
		$stats/VBoxContainer/changed_color.set_text("changed color " + str(stats[0]) + " times")
	if stats[1] == 0:
		$stats/VBoxContainer/square_jumps.set_text("nan")
	else:
		$stats/VBoxContainer/square_jumps.set_text("square jumps: " + str(stats[1]))
	if stats[2] == 0:
		$stats/VBoxContainer/car_jumps.set_text("nan")
	else:
		$stats/VBoxContainer/car_jumps.set_text("car jumps: " + str(stats[2]))
	if stats[3] == 0:
		$stats/VBoxContainer/phazed_laser.set_text("nan")
	else:
		$stats/VBoxContainer/phazed_laser.set_text("lasers phazed: " + str(stats[3]))
	if stats[4] == 0:
		$stats/VBoxContainer/survived_lava.set_text("nan")
	else:
		$stats/VBoxContainer/survived_lava.set_text("fires survived: " + str(stats[4]))
	if stats[5] == 0:
		$stats/VBoxContainer/placed_flags.set_text("nan")
	else:
		$stats/VBoxContainer/placed_flags.set_text("practice flags placed: " + str(stats[5]))
	if stats[6] == 0:
		$stats/VBoxContainer/paused.set_text("nan")
	else:
		$stats/VBoxContainer/paused.set_text("times paused: " + str(stats[6]))
	if stats[7] == 0:
		$stats/VBoxContainer/goals_reached.set_text("nan")
	else:
		$stats/VBoxContainer/goals_reached.set_text("goals reached: " + str(stats[7]))
	if stats[8] == 0:
		$stats/VBoxContainer/square_deaths.set_text("nan")
	else:
		$stats/VBoxContainer/square_deaths.set_text("squares killed: " + str(stats[8]))
	if stats[9] == 0:
		$stats/VBoxContainer/car_deaths.set_text("nan")
	else:
		$stats/VBoxContainer/car_deaths.set_text("cars killed: " + str(stats[9]))

func count_deaths(deaths: Array) -> int:
	var amount = 0
	for d in deaths:
		amount += d[0]
		amount += d[1]
	return amount


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
			deadliest = "square"
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
	var node = get_node("ScrollContainer/levels/" + level_name + "/TextureRect")
	var button_node = get_node("ScrollContainer/levels/" + level_name + "/TextureButton")
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


# called in mainMenu
func enable_level(level: int):
	var node = get_node("ScrollContainer/levels/level" + str(level) + "/TextureButton")
	if node != null:
		node.set_disabled(false)


# called in mainMenu
func show_checkmarks(level_number: int, cleared_normal: bool, cleared_practice: bool):
	var container = get_node("ScrollContainer/levels")
	var levels = container.get_children()
	var level = levels[level_number]
	if cleared_normal:
		get_node("ScrollContainer/levels/" + level.get_name() + "/TextureRect/HBoxContainer/TextureButton2/checkmark").show()
		get_node("ScrollContainer/levels/" + level.get_name() + "/TextureButton/checkmark").show()
	if cleared_practice:
		get_node("ScrollContainer/levels/" + level.get_name() + "/TextureRect/HBoxContainer/TextureButton/checkmark").show()


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
	hide_level_menu()


func _on_goBack_pressed() -> void:
	if get_parent().get_parent().SETTINGS[2]:
		$click.play()
	hide_level_menu()
	self.get_parent().show_menu()


func _on_stats_button_pressed(type: String) -> void:
	if get_parent().get_parent().SETTINGS[2]:
		$click.play()
	match type:
		"color":
			if $stats/VBoxContainer/deadliest_colors.visible:
				$stats/VBoxContainer/deadliest_colors.hide()
			else:
				$stats/VBoxContainer/deadliest_colors.show()
				$stats/VBoxContainer/deadliest_enemies.hide()
		"enemy":
			if $stats/VBoxContainer/deadliest_enemies.visible:
				$stats/VBoxContainer/deadliest_enemies.hide()
			else:
				$stats/VBoxContainer/deadliest_colors.hide()
				$stats/VBoxContainer/deadliest_enemies.show()
