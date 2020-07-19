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
var CURRENT_DEATHS: = 0 # amount of deaths on current run of current level
var DEATHS # amount of deaths in each stage
var CURRENT_LEVEL # name of most recent level as a string
var LEVEL_ORDER: = ["tutorial", "level1", "level2", "level3", "level4"] # order in which the levels should appear, used in mainMenu
var LEVELS_CLEARED # the amount of unique levels cleared in an array
var CAN_PAUSE = true

func _ready():
	START_TIME = OS.get_unix_time()
	load_savestate()
	mainmenu = MainMenu.instance()
	add_child(mainmenu)
	mainmenu.show_menu()
	mainmenu.start_music()


func _input(_event: InputEvent) -> void:
	if player:
		toggle_color()
		handle_action()
		handle_pause(false)


func _on_backMainMenu() -> void:
	remove_player_and_level()
	save_deaths()
	show_main_menu()


func play_level(levelName: String):
	CURRENT_LEVEL = levelName
	player = load("res://Source/Actors/player.tscn").instance()
	player.connect("levelcleared", self, "display_popup", ["levelCleared"])
	player.connect("playerdead", self, "restart_level", [levelName])
	level = load("res://Source/Levels/" + levelName + ".tscn").instance()
	hud = load("res://Source/Tutorials/playerHud.tscn").instance()
	add_child(level)
	add_child(player)
	add_child(hud)
	player.is_color("cyan")
	player.display_background(levelName)
	player.play_music(levelName)


func toggle_color():
	if Input.is_action_just_pressed("cyan"):
		player.is_color("cyan")
		level.play_animation("cyan")
	elif Input.is_action_just_pressed("red"):
		player.is_color("red")
		level.play_animation("red")
	elif Input.is_action_just_pressed("purple"):
		player.is_color("purple")
		level.play_animation("purple")
	elif Input.is_action_just_pressed("yellow"):
		player.is_color("yellow")
		level.play_animation("yellow")


func handle_action():
	if Input.is_action_just_pressed("action"):
		player.SPRING_JUMP = 10
		level.action(player.PLAYER_COLOR)

# auto is used when calling function from tutorial window.
func handle_pause(auto: bool):
	if ((Input.is_action_just_pressed("escape") or auto) and !player.DEAD) and CAN_PAUSE:
		$pauseMenu.show_menu()
		get_tree().paused = true
		CAN_PAUSE = false
	if Input.is_action_just_released("escape"):
		CAN_PAUSE = true


func player_cleared_level():
	save_deaths()
	if not LEVELS_CLEARED.has(CURRENT_LEVEL):
		LEVELS_CLEARED.append(CURRENT_LEVEL)
	save_game()
	mainmenu.show_level_menu()
	mainmenu.start_music()
	remove_player_and_level()


func save_deaths():
	DEATHS[LEVEL_ORDER.find(CURRENT_LEVEL)] += CURRENT_DEATHS
	save_game()
	CURRENT_DEATHS = 0


func save_game():
	TIME_PLAYED += OS.get_unix_time() - START_TIME
	var save_data = {
		"death_stats" : DEATHS,
		"levels_cleared" : LEVELS_CLEARED,
		"time_played" : TIME_PLAYED
	}
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	save_game.store_line(to_json(save_data))
	save_game.close()


func load_savestate():
	var load_game = File.new()
	if not load_game.file_exists("user://savegame.save"):
		DEATHS = [0, 0, 0, 0, 0, 0, 0, 0, 0]
		LEVELS_CLEARED = []
		TIME_PLAYED = 0
	else:
		load_game.open("user://savegame.save", File.READ)
		var savestate = parse_json(load_game.get_line())
		load_game.close()
		DEATHS = savestate.death_stats
		LEVELS_CLEARED = savestate.levels_cleared
		TIME_PLAYED = savestate.time_played


func restart_level(_levelName: String):
	# ADD save here if you don't want stats to disappear if the user would rage quit
	CURRENT_DEATHS += 1
	player.play_death_animation()
	yield(get_tree().create_timer(1), "timeout")
	remove_player_and_level()
	play_level(CURRENT_LEVEL)


func show_main_menu():
	mainmenu.show_menu()
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

