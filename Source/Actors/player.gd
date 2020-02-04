extends Actor

func _physics_process(delta: float) -> void:
	VELOCITY.y += GRAVITY * delta
	VELOCITY.x = MAX_SPEED.x
	VELOCITY = move_and_slide(VELOCITY, FLOOR_NORMAL)


func _on_enemy_head_entered(body: Node) -> void:
	print("yes")
	VELOCITY = body.get_velocity() # fixa en toggle som sätts på vid enter och stängs av vid exit.


func is_cyan():
	$player_sprite.play("cyan")

func is_red():
	$player_sprite.play("red")

func is_purple():
	$player_sprite.play("purple")

func is_yellow():
	$player_sprite.play("yellow")
