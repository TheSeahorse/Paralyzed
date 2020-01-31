extends Actor

func _physics_process(delta: float) -> void:
	_velocity.x = 300.0
	
	if Input.is_action_pressed("cyan"):
		$player_sprite.play("cyan")
		_color_status = 1
	elif Input.is_action_pressed("red"):
		$player_sprite.play("red")
		_color_status = 2
	elif Input.is_action_pressed("purple"):
		$player_sprite.play("purple")
		_color_status = 3
	elif Input.is_action_pressed("yellow"):
		$player_sprite.play("yellow")
		_color_status = 4
	
	_velocity = move_and_slide(_velocity)
