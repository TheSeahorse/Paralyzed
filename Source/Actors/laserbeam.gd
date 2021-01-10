extends Area2D
class_name LaserBeam

export var COLOR: = "cyan"
var BEAMING: bool #used in car to tell if beam is on or not

func _ready() -> void:
	if COLOR == "cyan":
		BEAMING = false
		$beam_sprite.play(str(COLOR, " fade"))
	else:
		BEAMING = true
		$beam_sprite.play(COLOR)


func change_color(color: String, player_color: String):
	COLOR = color
	if color == player_color:
		BEAMING = false
		$beam_sprite.play(str(color, " fade"))
	else:
		BEAMING = true
		$beam_sprite.play(color)


func fade_out():
	BEAMING = false
	$beam_sprite.play(str(COLOR, " fade"))


func fade_in():
	BEAMING = true
	$beam_sprite.play(COLOR)

