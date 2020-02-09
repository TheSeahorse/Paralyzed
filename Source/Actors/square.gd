extends Actor
class_name Square

export var COLOR: = "cyan"
var TOGGLE_ACTION: = false
var SPRING_JUMP: = 0

func _ready() -> void:
	if COLOR == "cyan":
		$square_sprite.play("cyan")
	elif COLOR == "red":
		$square_sprite.play("red")
	elif COLOR == "purple":
		$square_sprite.play("purple")
	elif COLOR == "yellow":
		$square_sprite.play("yellow")

func _physics_process(delta: float) -> void:
	var direction: = Vector2(0.0,0.0)
	if TOGGLE_ACTION:
		direction = jump()
	VELOCITY = calculate_move_velocity(VELOCITY, direction, delta)
	VELOCITY = move_and_slide(VELOCITY, FLOOR_NORMAL)


func jump() -> Vector2:
	TOGGLE_ACTION = false
	print("jump_before")
	if is_on_floor():
		print("jump")
		SPRING_JUMP = 23
		return Vector2(0.0, -1.0)
	else:
		return Vector2(0.0, 0.0)


func calculate_move_velocity(linear_velocity: Vector2, direction: Vector2, delta: float) -> Vector2:
	if direction.y == -1.0:
		linear_velocity.y = direction.y * MAX_SPEED.y * 2 #faster rise
	elif SPRING_JUMP > 20:
		linear_velocity.y += delta #climb without gravity
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
