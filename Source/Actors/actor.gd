extends KinematicBody2D
class_name Actor

const FLOOR_NORMAL: = Vector2.UP
export var MAX_SPEED: = Vector2(300.0, 1500.0)
export var GRAVITY: = 4000.0
var VELOCITY: = Vector2.ZERO
var COLOR_STATUS: = "cyan"

func get_velocity() -> Vector2:
	return VELOCITY


func get_color_status() -> String:
	return COLOR_STATUS
