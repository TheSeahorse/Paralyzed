extends KinematicBody2D
class_name Actor

export var _maxspeed: = Vector2(500.0, 2000.0)
export var _gravity: = 1000.0
var _velocity: = Vector2.ZERO
var _color_status: = 1

func _physics_process(delta: float) -> void:
	_velocity.y += _gravity*delta
	_velocity = move_and_slide(_velocity)
