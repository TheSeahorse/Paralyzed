extends Actor

func _physics_process(delta: float) -> void:
	toggle_color()
	VELOCITY.y += GRAVITY * delta
	VELOCITY.x = MAX_SPEED.x
	VELOCITY = move_and_slide(VELOCITY, FLOOR_NORMAL)


func _on_enemy_head_entered(body: Node) -> void:
	VELOCITY = body.get_velocity() # DU ÄR HÄR


func toggle_color():
	if Input.is_action_just_pressed("cyan"):
		$player_sprite.play("cyan")
	elif Input.is_action_just_pressed("red"):
		$player_sprite.play("red")
	elif Input.is_action_just_pressed("purple"):
		$player_sprite.play("purple")
	elif Input.is_action_just_pressed("yellow"):
		$player_sprite.play("yellow")


