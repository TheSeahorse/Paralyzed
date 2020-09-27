extends Area2D
class_name LaserBeam

export var COLOR: = "cyan"
var BEAMING: bool #used in car to tell if beam is on or not

func _ready() -> void:
	if COLOR == "cyan":
		BEAMING = true
		$beam_sprite.play(str(COLOR, " fade"))
	else:
		BEAMING = false
		$beam_sprite.play(COLOR)


func fade_out():
	BEAMING = false
	$beam_sprite.play(str(COLOR, " fade"))


func fade_in():
	BEAMING = true
	$beam_sprite.play(COLOR)

