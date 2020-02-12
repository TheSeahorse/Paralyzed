extends Area2D
class_name LaserBeam

export var COLOR: = "cyan"

func _ready() -> void:
	$beam_sprite.play(COLOR)


func play_anim():
	print("yes")
	$beam_sprite.play(str(COLOR, " fade"))


func stop_anim():
	$beam_sprite.play(COLOR)


func get_color() -> String:
	return COLOR
