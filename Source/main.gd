extends Node2D

const MainMenu = preload("res://Source/Menues/mainMenu.tscn")

var mainmenu # main menu node
var player # player node
var level # current level node
var gameover # game over menu node

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
	if player or level:
		remove_player_and_level()
	show_main_menu()


func _on_gameover_restartLevel() -> void:
	play_level(CURRENT_LEVEL)


func play_level(levelName: String):
	CURRENT_LEVEL = levelName
	player = load("res://Source/Actors/player.tscn").instance()
	player.connect("levelcleared", self, "player_cleared_level", [levelName])
	player.connect("playerdead", self, "restart_level", [levelName])
	level = load("res://Source/Levels/" + levelName + ".tscn").instance()
	add_child(level)
	add_child(player)
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


func handle_pause(auto: bool):
	if Input.is_action_just_pressed("escape") or auto:
		$pauseMenu.show_menu()
		get_tree().paused = true


func player_cleared_level(nlevel: String):
	if not LEVELS_CLEARED.has(nlevel):
		LEVELS_CLEARED.append(nlevel)
		var next_level = LEVEL_ORDER[LEVEL_ORDER.find(nlevel) + 1]
		mainmenu.levelmenu_show_level(next_level)
	mainmenu.show_level_menu() 
	remove_player_and_level()


func restart_level(_levelName: String):
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


func display_popup(tutorial_name: String):
	var tutorial = load("res://Source/Tutorials/" + tutorial_name + ".tscn").instance()
	add_child(tutorial)
	get_tree().paused = true

