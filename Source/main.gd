extends Node2D

const MainMenu = preload("res://Source/Menues/mainMenu.tscn")

var mainmenu # main menu node
var player # player node
var level # current level node
var hud # the player hud
var gameover # game over menu node

var CURRENT_DEATHS: = 0 # amount of deaths on current run of current level
var DEATHS: = [0, 0, 0, 0, 0, 0, 0, 0, 0] # amount of deaths in each stage
var CURRENT_LEVEL # name of most recent level as a string
var LEVEL_ORDER: = ["tutorial", "level1", "level2", "level3", "level4", "level5", "level6", "level7", "level8"] # order in which the levels should appear
var LEVELS_CLEARED: = [] # the amount of unique levels cleared in an array

func _ready():
	mainmenu = MainMenu.instance()
	add_child(mainmenu)
	mainmenu.show_menu()


func _input(_event: InputEvent) -> void:
	if player:
		toggle_color()
		handle_action()
		handle_pause(false)


func _on_backMainMenu() -> void:
	remove_player_and_level()
	add_deaths(CURRENT_LEVEL)
	show_main_menu()


func play_level(levelName: String):
	CURRENT_LEVEL = levelName
	player = load("res://Source/Actors/player.tscn").instance()
	player.connect("levelcleared", self, "player_cleared_level", [levelName])
	player.connect("playerdead", self, "restart_level", [levelName])
	level = load("res://Source/Levels/" + levelName + ".tscn").instance()
	hud = load("res://Source/Tutorials/playerHud.tscn").instance()
	add_child(level)
	add_child(player)
	add_child(hud)
	player.is_color("cyan")


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
	if (Input.is_action_just_pressed("escape") or auto) and !player.DEAD:
		$pauseMenu.show_menu()
		get_tree().paused = true


func player_cleared_level(level_name: String):
	add_deaths(level_name)
	print(DEATHS)
	if not LEVELS_CLEARED.has(level_name):
		LEVELS_CLEARED.append(level_name)
		var next_level = LEVEL_ORDER[LEVEL_ORDER.find(level_name) + 1]
		mainmenu.levelmenu_show_level(next_level)
	mainmenu.show_level_menu() 
	remove_player_and_level()


func add_deaths(level_name: String):
	DEATHS[LEVEL_ORDER.find(level_name)] += CURRENT_DEATHS
	CURRENT_DEATHS = 0
	CURRENT_LEVEL = null


func restart_level(_levelName: String):
	CURRENT_DEATHS += 1
	player.play_death_animation()
	yield(get_tree().create_timer(1), "timeout")
	remove_player_and_level()
	play_level(CURRENT_LEVEL)


func show_main_menu():
	mainmenu.show_menu()


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

