extends Actor

func _physics_process(delta: float) -> void:
	var direction: = get_direction()
	VELOCITY = calculate_move_velocity(VELOCITY, direction, delta)
	VELOCITY = move_and_slide(VELOCITY, FLOOR_NORMAL)


func get_direction() -> Vector2:
	if Input.is_action_just_pressed("action") && is_on_floor():
		return Vector2(0.0,-1.0)
	else:
		return Vector2(0.0,0.0)


func calculate_move_velocity(linear_velocity: Vector2, direction: Vector2, delta: float) -> Vector2:
	var new_velocity: = linear_velocity
	new_velocity.y += GRAVITY * 0.8 * delta #slighty "slower" jump
	if direction.y == -1.0:
		new_velocity.y = direction.y * MAX_SPEED.y
	return new_velocity
