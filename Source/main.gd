extends Node2D

const Player = preload("res://Source/Actors/player.tscn")
const LevelTemplate = preload("res://Source/Levels/LevelTemplate.tscn")

var player
var leveltemplate

func _ready():
	player = Player.instance()
	leveltemplate = LevelTemplate.instance()
	add_child(player)
	add_child(leveltemplate)
	player.is_cyan()


func _physics_process(delta: float) -> void:
	toggle_color()
	handle_action()


func handle_action():
	if Input.is_action_just_pressed("action"):
		#player.activate_spring_jump()
		leveltemplate.action(player.PLAYER_COLOR)


func toggle_color():
	if Input.is_action_just_pressed("cyan"):
		player.is_cyan()
	elif Input.is_action_just_pressed("red"):
		player.is_red()
	elif Input.is_action_just_pressed("purple"):
		player.is_purple()
	elif Input.is_action_just_pressed("yellow"):
		player.is_yellow()
