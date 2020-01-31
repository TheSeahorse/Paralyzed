extends Actor

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("jump"): 
		_velocity.y = 500.0
		
	_velocity = move_and_slide(_velocity)
	
#func calculate_move(linear_velocity: Vector2, ) -> Velocity2:
