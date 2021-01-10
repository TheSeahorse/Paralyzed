extends Node2D

const MainMenu = preload("res://Source/Menues/mainMenu.tscn")

var mainmenu # main menu node
var player # player node
var level # current level node
var hud # the player hud
var gameover # game over menu node

var START_TIME # the unix.time the game booted up
var LEVEL_START_TIME # the unix.time current level started playing
var TIME_PLAYED # the total time the game has been played in seconds (since last save)
var CURRENT_DEATHS: int = 0 # amount of deaths on current run of current level
var DEATHS: Array # array of arrays with [normal,practice] structure, in order of the levels
var DEATH_BY: Array # [spikes, square, beam, lava, car, self-destruct]
var DEADLIEST_COLOR: Array # how many times you've died to each color [cyan, red, purple, yellow, none]
var STATS: Array # [switched-color, square-jumped, car-jumped, phazed-beam, phazed-lava, placed-flag, paused, goals-reached, square-killed, car-killed]
var CURRENT_LEVEL # name of most recent level as a string
var ENDLESS # if we're in endless mode
var PRACTICE # true if practice play is on, false if real play is on
var PRACTICE_SAVED_PLAYER_VECTORS: = [] # all the saved player positions from first to last in a practice round
var PRACTICE_SAVED_PLAYER_VELOCITIES: = [] # all the saved player velocities from first to last in a practice round
var LEVEL_ORDER: Array = ["tutorial", "level1", "level2", "level3", "level4", "level5", "level6", "level7", "level8", "level9", "level10", "level11", "level12", "level13", "level14", "level15", "level16", "level17", "level18", "level19", "level20"] # order in which the levels should appear, used in mainMenu
var LEVELS_CLEARED: Array # array of arrays in format [[true, false], [false, true]] where [normal_level, practice_level] and all levels are in order, tutorial first
var CAN_PAUSE: = true # whether or not the player can input pause by pressing esacape, cant if in menues
var SETTINGS: Array #settings in an array HUD, Music, Sound, Fullscreen, Borderless, White_Background, Double_click_jump
var RNG = RandomNumberGenerator.new()

func _ready():
	RNG.randomize()
	START_TIME = OS.get_unix_time()
	load_savestate()
	mainmenu = MainMenu.instance()
	add_child(mainmenu)
	mainmenu.show_menu()
	apply_settings()


func _input(_event: InputEvent) -> void:
	if player:
		toggle_color()
		handle_action()
		handle_pause(false)
		if PRACTICE:
			if !player.DEAD:
				handle_practice_save()
			handle_practice_delete_save()
			if Input.is_action_just_pressed("sd"):
				kill_player("sd", "none")


#signal from PauseMenu
func _on_backMainMenu() -> void:
	stop_music()
	CAN_PAUSE = true
	PRACTICE_SAVED_PLAYER_VECTORS = []
	PRACTICE_SAVED_PLAYER_VELOCITIES = []
	remove_player_and_level()
	save_deaths()
	show_main_menu()


#signal from PauseMenu
func _on_resart() -> void:
	CAN_PAUSE = true
	PRACTICE_SAVED_PLAYER_VECTORS = []
	PRACTICE_SAVED_PLAYER_VELOCITIES = []
	remove_player_and_level()
	play_level(CURRENT_LEVEL, PRACTICE)


func play_level(levelName: String, practice: bool):
	if levelName == "endless":
		ENDLESS = true
	else:
		ENDLESS = false
	PRACTICE = practice
	CURRENT_LEVEL = levelName
	player = load("res://Source/Actors/player.tscn").instance()
	player.connect("levelcleared", self, "display_popup", ["levelCleared"])
	player.connect("playerdead", self, "player_died")
	level = load("res://Source/Levels/" + levelName + ".tscn").instance()
	if SETTINGS[0]:
		hud = load("res://Source/Tutorials/playerHud.tscn").instance()
		add_child(hud)
		if ENDLESS:
			hud.show_score()
	add_child(player)
	add_child(level)
	if PRACTICE:
		if !PRACTICE_SAVED_PLAYER_VECTORS.empty():
			player.position = PRACTICE_SAVED_PLAYER_VECTORS.back()
			player.VELOCITY = PRACTICE_SAVED_PLAYER_VELOCITIES.back()
			level.spawn_flag(player.position)
	player.is_color("cyan")
	player.display_background(levelName)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	if SETTINGS[1]:
		play_music()


func play_music():
	if PRACTICE or CURRENT_LEVEL == "tutorial" or CURRENT_LEVEL == "endless":
		if !$practice.is_playing():
			$practice.play()
	elif CURRENT_LEVEL.length() < 8:
		var nr = (CURRENT_LEVEL.substr(5)).to_int()
		if (nr < 5):
			$cube.play(0.0)
		elif (nr < 9):
			$laser.play(0.0)
		elif (nr < 13):
			$lava.play(0.0)
		elif (nr < 17):
			$car.play(0.0)
		else:
			$all.play(0.0)


func stop_music():
	$cube.stop()
	$laser.stop()
	$lava.stop()
	$car.stop()
	$all.stop()
	$practice.stop()


func toggle_color():
	if Input.is_action_just_pressed("cyan"):
		handle_color_change("cyan")
	elif Input.is_action_just_pressed("red"):
		handle_color_change("red")
	elif Input.is_action_just_pressed("purple"):
		handle_color_change("purple")
	elif Input.is_action_just_pressed("yellow"):
		handle_color_change("yellow")


func handle_color_change(color: String):
	if player.PLAYER_COLOR != color:
		player.is_color(color)
		level.play_animation(color)
	elif SETTINGS[6]:
		player.try_jump()
		level.action(color)


func handle_action():
	if Input.is_action_just_pressed("action"):
		player.try_jump()
		level.action(player.PLAYER_COLOR)


# auto is used when calling function from tutorial window.
func handle_pause(auto: bool):
	if ((Input.is_action_just_pressed("escape") or auto) and !player.DEAD) and CAN_PAUSE:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		add_stat("paused", 1)
		$pauseMenu.show_menu()
		get_tree().paused = true
		CAN_PAUSE = false
	if Input.is_action_just_released("escape"):
		CAN_PAUSE = true


func handle_practice_save():
	if Input.is_action_just_pressed("flag"):
		if SETTINGS[2]:
			$flag_flap.play()
		var player_position = player.position
		PRACTICE_SAVED_PLAYER_VECTORS.append(player_position)
		PRACTICE_SAVED_PLAYER_VELOCITIES.append(player.VELOCITY)
		level.spawn_flag(player_position)
		add_stat("placed-flag", 1)


func handle_practice_delete_save():
	if Input.is_action_just_pressed("remove"):
		PRACTICE_SAVED_PLAYER_VELOCITIES.pop_back()
		if PRACTICE_SAVED_PLAYER_VECTORS.pop_back() != null:
			if SETTINGS[2]:
				$flag_remove.play()


func kill_player(cause: String, color: String):
		if !player.DEAD:
			player.player_dead(cause, color)


func player_cleared_level():
	stop_music()
	save_deaths()
	calculate_cleared_level()
	PRACTICE_SAVED_PLAYER_VECTORS = []
	PRACTICE_SAVED_PLAYER_VELOCITIES = []
	save_game()
	mainmenu.show_level_menu()
	if SETTINGS[1]:
		mainmenu.start_music()
	add_stat("goals-reached", 1)
	remove_player_and_level()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func calculate_cleared_level():
	var index = LEVEL_ORDER.find(CURRENT_LEVEL)
	var current_clear_array = LEVELS_CLEARED[index]
	if PRACTICE:
		current_clear_array[1] = true
	else:
		current_clear_array[0] = true
	LEVELS_CLEARED[index] = current_clear_array


# I DEATHS arrayen ska det vara [normal_deaths: int, practice_deaths: int]
func save_deaths():
	var current_level_deaths = DEATHS[LEVEL_ORDER.find(CURRENT_LEVEL)]
	if PRACTICE:
		current_level_deaths[1] += CURRENT_DEATHS
	else:
		current_level_deaths[0] += CURRENT_DEATHS
	DEATHS[LEVEL_ORDER.find(CURRENT_LEVEL)] = current_level_deaths
	save_game()
	CURRENT_DEATHS = 0


func save_game():
	TIME_PLAYED += OS.get_unix_time() - START_TIME
	var save_data = {
		"death_stats" : DEATHS,
		"levels_cleared" : LEVELS_CLEARED,
		"time_played" : TIME_PLAYED,
		"death_by" : DEATH_BY,
		"stats" : STATS,
		"deadliest_color" : DEADLIEST_COLOR,
		"settings" : SETTINGS
	}
	var save_game = File.new()
	save_game.open("user://paralyzed_savegame.save", File.WRITE)
	save_game.store_line(to_json(save_data))
	save_game.close()


func load_savestate():
	var load_game = File.new()
	if not load_game.file_exists("user://paralyzed_savegame.save"):
		DEATHS = [[0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0]]
		LEVELS_CLEARED = [[false, false], [false, false], [false, false], [false, false], [false, false], [false, false], [false, false], [false, false], [false, false], [false, false], [false, false], [false, false], [false, false], [false, false], [false, false], [false, false], [false, false], [false, false], [false, false], [false, false], [false, false]]
		TIME_PLAYED = 0
		DEATH_BY = [0, 0, 0, 0, 0, 0]
		STATS = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
		DEADLIEST_COLOR = [0, 0, 0, 0, 0]
		SETTINGS = [true, true, true, false, false, false, false]
	else:
		load_game.open("user://paralyzed_savegame.save", File.READ)
		var savestate = parse_json(load_game.get_line())
		load_game.close()
		if savestate.has("death_stats"):
			DEATHS = savestate.death_stats
		else:
			DEATHS = [[0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0]]
		if savestate.has("levels_cleared"):
			LEVELS_CLEARED = savestate.levels_cleared
		else:
			LEVELS_CLEARED = [[false, false], [false, false], [false, false], [false, false], [false, false], [false, false], [false, false], [false, false], [false, false], [false, false], [false, false], [false, false], [false, false], [false, false], [false, false], [false, false], [false, false], [false, false], [false, false], [false, false], [false, false]]
		if savestate.has("time_played"):
			TIME_PLAYED = savestate.time_played
		else:
			TIME_PLAYED = 0
		if savestate.has("death_by"):
			DEATH_BY = savestate.death_by
		else:
			DEATH_BY = [0, 0, 0, 0, 0, 0]
		if savestate.has("stats"):
			STATS = savestate.stats
		else:
			STATS = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
		if savestate.has("deadliest_color"):
			DEADLIEST_COLOR = savestate.deadliest_color
		else:
			DEADLIEST_COLOR = [0, 0, 0, 0, 0]
		if savestate.has("settings"):
			SETTINGS = savestate.settings
		else:
			SETTINGS = [true, true, true, false, false, false, false]


func apply_settings():
	if SETTINGS[1]:
		mainmenu.start_music()


func player_died(cause: String, color: String):
	# ADD save here if you don't want stats to disappear if the user would rage quit
	add_deadliest_color(color)
	add_death_by(cause)
	CURRENT_DEATHS += 1
	player.play_death_animation()
	yield(get_tree().create_timer(1), "timeout")
	remove_player_and_level()
	play_level(CURRENT_LEVEL, PRACTICE)


# DEATH_BY: [spikes, square, beam, lava, car, self-destruct]
func add_death_by(cause: String):
	match cause:
		"spikes":
			DEATH_BY[0] += 1
		"square":
			DEATH_BY[1] += 1
		"beam":
			DEATH_BY[2] += 1
		"lava":
			DEATH_BY[3] += 1
		"car":
			DEATH_BY[4] += 1
		"sd":
			DEATH_BY[5] += 1


# Dangerous_color [cyan, red, purple, yellow, none]
func add_deadliest_color(color: String):
	match color:
		"cyan":
			DEADLIEST_COLOR[0] += 1
		"red":
			DEADLIEST_COLOR[1] += 1
		"purple":
			DEADLIEST_COLOR[2] += 1
		"yellow":
			DEADLIEST_COLOR[3] += 1
		"none":
			DEADLIEST_COLOR[4] += 1


# STATS: [switched-color, square-jumped, car-jumped, phazed-beam, phazed-lava, placed-flag, paused]
func add_stat(stat: String, amount: int):
	if stat == "switch-color":
		STATS[0] += amount
	elif stat == "square-jump":
		STATS[1] += amount
	elif stat == "car-jump":
		STATS[2] += amount
	elif stat == "phazed-beam":
		STATS[3] += amount
	elif stat == "phazed-lava":
		STATS[4] += amount
	elif stat == "placed-flag":
		STATS[5] += amount
	elif stat == "paused":
		STATS[6] += amount
	elif stat == "goals-reached":
		STATS[7] += amount
	elif stat == "square-killed":
		STATS[8] += amount
	elif stat == "car-killed":
		STATS[9] += amount


func update_endless_score(score: int):
	if hud:
		hud.update_endless_score(score)


func show_main_menu():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mainmenu.show_menu()
	if SETTINGS[1]:
		mainmenu.start_music()


func remove_player_and_level():
	if player:
		player.queue_free()
		player = null
	if level:
		level.queue_free()
		level = null
	if hud:
		hud.queue_free()
		hud = null


func display_popup(tutorial_name: String):
	var tutorial = load("res://Source/Tutorials/" + tutorial_name + ".tscn").instance()
	add_child(tutorial)
	get_tree().paused = true


# called from levelMenu
func set_level_start_time():
	LEVEL_START_TIME = OS.get_unix_time()
