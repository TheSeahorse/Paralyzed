extends Node2D

const MainMenu = preload("res://Source/Menues/mainMenu.tscn")
const GameOver = preload("res://Source/Menues/gameover.tscn")

var mainmenu
var player
var level
var gameover

func _ready():
	mainmenu = MainMenu.instance()
	add_child(mainmenu)


func _input(event: InputEvent) -> void:
	if player:
		toggle_color()
		handle_action()


func play_level(levelName: String):
	if gameover and gameover.visible:
		gameover.hide()
	player = load("res://Source/Actors/player.tscn").instance()
	player.connect("levelcleared", self, "player_cleared_level")
	player.connect("playerdead", self, "game_over_screen", [levelName])
	level = load("res://Source/Levels/" + levelName + ".tscn").instance()
	add_child(player)
	add_child(level)
	player.is_cyan()


func toggle_color():
	if Input.is_action_just_pressed("cyan"):
		player.is_cyan()
		level.play_animation("cyan")
	elif Input.is_action_just_pressed("red"):
		player.is_red()
		level.play_animation("red")
	elif Input.is_action_just_pressed("purple"):
		player.is_purple()
		level.play_animation("purple")
	elif Input.is_action_just_pressed("yellow"):
		player.is_yellow()
		level.play_animation("yellow")


func handle_action():
	if Input.is_action_just_pressed("action"):
		player.SPRING_JUMP = 10
		level.action(player.PLAYER_COLOR)


func player_cleared_level():
	remove_child(player)
	player.queue_free()
	remove_child(level)
	level.queue_free()
	mainmenu.get_child(0).show()


func game_over_screen(levelName: String):
	remove_child(player)
	player.queue_free()
	remove_child(level)
	level.queue_free()
	if !gameover:
		gameover = GameOver.instance()
		gameover.connect("backMenu", self, "show_main_menu")
		gameover.connect("restartLevel", self, "play_level", [levelName])
		add_child(gameover)
	gameover.show()


func show_main_menu():
	gameover.hide()
	mainmenu.get_child(0).show()
