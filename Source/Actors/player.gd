extends Actor
class_name Player
signal levelcleared
signal playerdead

var PLAYER_COLOR: = "cyan"
var DEAD: = false
var ON_HEADS: = 0 # the amount of enemy heads the player is currently on
var ON_BEAM: = false # true if player is currently on a beam
var BEAM_COLOR # color of the beam the player is on
var SQUARE1 # left most square the player is on (if on only one square this var is used)
var SQUARE2 # right most square the player is on (only if player is on two squares)
var SPRING_JUMP: = 0 # if a spring jump is activated this value is greater than 0


func _physics_process(delta: float) -> void:
	if DEAD:
		VELOCITY = move_and_slide(Vector2(0,0), FLOOR_NORMAL)
	else:
		check_if_dead()
		VELOCITY.x = MAX_SPEED.x
		VELOCITY = calculate_y(VELOCITY, delta)
		VELOCITY = move_and_slide(VELOCITY, FLOOR_NORMAL)


func _on_enemy_head_entered(body: Node) -> void:
	if body is Square and body.ON_FLOOR:
		ON_HEADS += 1
		if ON_HEADS == 1:
			SQUARE1 = body
		else:
			SQUARE2 = body


func _on_enemy_head_body_exited(body: Node) -> void:
	if body is Square:
		ON_HEADS -= 1
		if ON_HEADS == 0:
			SQUARE1 = null
		else:
			SQUARE1 = SQUARE2
			SQUARE2 = null


func _on_Deathcollision_area_entered(area: Area2D) -> void:
	if DEAD:
		return
	if area is LaserBeam:
		ON_BEAM = true
		BEAM_COLOR = area.COLOR
		get_parent().add_stat("phazed-beam", 1)
	elif area is Spikes:
		if area.get_parent() is Square:
			call_deferred("player_dead", "square", area.get_parent().COLOR)
		else:
			call_deferred("player_dead", "spikes", "none")
	elif area is Goal:
		emit_signal("levelcleared")
	elif area.get_parent() is Car:
		call_deferred("player_dead", "car", area.get_parent().COLOR)


func _on_Deathcollision_area_exited(area: Area2D) -> void:
	if area is LaserBeam:
		ON_BEAM = false
		BEAM_COLOR = null


func player_dead(cause: String, color: String):
	get_node("Hitbox").disabled = true
	DEAD = true
	if !get_parent().PRACTICE and !(get_parent().CURRENT_LEVEL == "tutorial"):
		get_parent().stop_music()
	if get_parent().SETTINGS[2]:
		$death.play()
	emit_signal("playerdead", cause, color)


func play_death_animation():
	$player_sprite.play(PLAYER_COLOR + " dead")


func check_if_dead():
	if ON_BEAM and PLAYER_COLOR != BEAM_COLOR:
		call_deferred("player_dead", "beam", BEAM_COLOR)
		get_parent().add_stat("phazed-beam", -1)


func calculate_y(velocity: Vector2, delta: float) -> Vector2:
	# Om vi hoppar på ett huvud och square1 eller square2(givet sqaure2 finns) är samma färg som oss, hoppa.
	if ((ON_HEADS > 0 and SPRING_JUMP == 10) and
		((SQUARE1.COLOR == PLAYER_COLOR) or ((SQUARE2 and SQUARE2.COLOR == PLAYER_COLOR)))):
		velocity.y = -1.0 * MAX_SPEED.y * 2
		SPRING_JUMP -= 1
	elif SPRING_JUMP == 10: #then we were not on a head
		SPRING_JUMP = 0
	elif SPRING_JUMP > 0:
		velocity.y += GRAVITY * delta
		SPRING_JUMP -= 1
	else:
		velocity.y += GRAVITY * delta
	return velocity


func display_background(level: String):
	if get_parent().SETTINGS[5]:
		$ParallaxBackground/background.play("white")
	elif level.length() == 8:
		$ParallaxBackground/background.play("tutorial")
	else:
		var nr = (level.substr(5)).to_int()
		if (nr < 5):
			$ParallaxBackground/background.play("cube")
		elif (nr < 9):
			$ParallaxBackground/background.play("laser")
		elif (nr < 13):
			$ParallaxBackground/background.play("lava")
		elif (nr < 17):
			$ParallaxBackground/background.play("car")
		else:
			$ParallaxBackground/background.play("all")


func is_color(color: String):
	if DEAD:
		return
	if color == PLAYER_COLOR:
		return
	else:
		$player_sprite.play(PLAYER_COLOR + " to " + color)
		if get_parent().SETTINGS[2]:
			$change_color.play()
		PLAYER_COLOR = color
		get_parent().add_stat("switch-color", 1)


func try_jump():
	SPRING_JUMP = 10
