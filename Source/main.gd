extends Node2D

const MainMenu = preload("res://Source/Menues/mainMenu.tscn")

var mainmenu
var player
var level

func _ready():
	mainmenu = MainMenu.instance()
	add_child(mainmenu)


func _input(event: InputEvent) -> void:
	if player:
		toggle_color()
		handle_action()


func play_level(levelName: String):
	player = load("res://Source/Actors/player.tscn").instance()
	player.connect("levelcleared", self, "playerClearedLevel")
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


func playerClearedLevel():
	print("playerclear")
	player.queue_free()
	level.queue_free()
	mainmenu.get_child(0).show()
	
