extends Actor
class_name Lava

export var COLOR: = "cyan"
var PLAYER_ON: = false
var PLAYER
var BURNING: bool #used by car to see if burning or not

func _init():
	GRAVITY = 0

func _ready():
	if COLOR == "cyan":
		BURNING = true
		$sprite.play("cyan on")
	else:
		BURNING = false
		$sprite.play(COLOR + " off")


func _process(_delta: float) -> void:
	if PLAYER_ON and (PLAYER.PLAYER_COLOR == COLOR):
		get_parent().get_parent().kill_player("lava", COLOR)
		get_parent().get_parent().add_stat("phazed-lava", -1)
		PLAYER_ON = false

func turn_on():
	BURNING = true
	$sprite.play(COLOR + " on")


func turn_off():
	BURNING = false
	$sprite.play(COLOR + " off")


func _on_Area2D_area_entered(area: Area2D) -> void:
	if area.get_name() == "Deathcollision":
		PLAYER = area.get_parent()
		PLAYER_ON = true


func _on_Area2D_area_exited(area: Area2D) -> void:
	if area.get_name() == "Deathcollision":
		PLAYER_ON = false
		get_parent().get_parent().add_stat("phazed-lava", 1)
