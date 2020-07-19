extends Actor
class_name Car

export var COLOR: = "cyan"
var ENABLED: = false # turns true the first time physics process is called
var TOGGLE_ACTION: = false #if "action" has been input by the user
var ON_FLOOR: = true #if the square is on any kind of KinematicBody2D

func _ready() -> void:
	$car_sprite.play(COLOR)
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	if !ENABLED:
		TOGGLE_ACTION = false
		ENABLED = true
	if TOGGLE_ACTION:
		jump()
	VELOCITY.x =- MAX_SPEED.x
	VELOCITY = calculate_move_velocity(VELOCITY, delta)
	VELOCITY = move_and_slide(VELOCITY, FLOOR_NORMAL)

func calculate_move_velocity(linear_velocity: Vector2, delta: float) -> Vector2:
	linear_velocity.y += GRAVITY * delta
	return linear_velocity


func jump() -> void:
	TOGGLE_ACTION = false
	if ON_FLOOR:
		VELOCITY.y =- MAX_SPEED.y
		ON_FLOOR = false


func _on_Area2D_body_exited(_body: Node) -> void:
	ON_FLOOR = false


func _on_Area2D_body_entered(_body: Node) -> void:
	ON_FLOOR = true
