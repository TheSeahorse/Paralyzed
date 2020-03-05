extends Area2D
class_name LaserBeam

export var COLOR: = "cyan"

func _ready() -> void:
	$beam_sprite.play(COLOR)


func fade_out():
	$beam_sprite.play(str(COLOR, " fade"))


func fade_in():
	$beam_sprite.play(COLOR)


func get_color() -> String:
	return COLOR
