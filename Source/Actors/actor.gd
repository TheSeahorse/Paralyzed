extends KinematicBody2D
class_name Actor

const FLOOR_NORMAL: = Vector2.UP
export var MAX_SPEED: = Vector2(400.0, 1000.0)
export var GRAVITY: = 3000.0
var VELOCITY: = Vector2.ZERO


func get_velocity() -> Vector2:
	return VELOCITY
