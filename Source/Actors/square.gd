extends Actor
class_name Square

export var COLOR: = "cyan"
var TOGGLE_ACTION: = false #if "action" has been input by the user
var ON_FLOOR: = false #if the square is on any kind of KinematicBody2D
var SPRING_JUMP: = 0 #variable to control the flingy jump of the square, if greater than 0 we're calculating the jump

func _ready() -> void:
	$square_sprite.play(COLOR)

func _physics_process(delta: float) -> void:
	if TOGGLE_ACTION:
		jump()
	VELOCITY = calculate_move_velocity(VELOCITY, delta)
	VELOCITY = move_and_slide(VELOCITY, FLOOR_NORMAL)


func _on_tileMap_body_entered(body: Node) -> void: #Area2D, not tilemap
	ON_FLOOR = true


func _on_tileMap_body_exited(body: Node) -> void: #Area2D, not tilemap
	ON_FLOOR = false #this gets changed faster in the jump functions


func jump() -> Vector2:
	TOGGLE_ACTION = false
	if ON_FLOOR:
		ON_FLOOR = false
		SPRING_JUMP = 26
		return Vector2(0.0, -1.0)
	else:
		return Vector2(0.0, 0.0)


func calculate_move_velocity(linear_velocity: Vector2, delta: float) -> Vector2:
	if SPRING_JUMP == 25 or SPRING_JUMP == 26: #stall for two fram so that the player jump works
		SPRING_JUMP -= 1 
	elif SPRING_JUMP == 24:
		linear_velocity.y = -1.0 * MAX_SPEED.y * 2 #faster rise
		SPRING_JUMP -= 1
	elif SPRING_JUMP > 15: 
		linear_velocity.y += GRAVITY * delta #start decreasing speed
		SPRING_JUMP -= 1
	elif SPRING_JUMP > 0: 
		linear_velocity.y = 0.0 #stop for a short while
		SPRING_JUMP -= 1
	else:
		linear_velocity.y += GRAVITY * 0.3 * delta #slower fall
	
	return linear_velocity
