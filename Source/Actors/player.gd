extends Actor
class_name Player
signal levelcleared
signal playerdead

var PLAYER_COLOR: = "cyan"
var DEAD: = false
var ON_HEADS: = 0 # the amount of enemy heads the player is currently on
var ON_LAVA: = 0 # the amount of lava tiles the player is currently on
var ON_BEAM: = false # true if player is currently on a beam
var BEAM_COLOR # color of the beam the player is on
var SQUARE1 # left most square the player is on (if on only one square this var is used)
var SQUARE2 # right most square the player is on (only if player is on two squares)
var LAVA1 # left most lava tile the player is on (if on only one tile this var is used)
var LAVA2 # right most lava tile the player is on (only if player is on two tiles)
var SPRING_JUMP: = 0 # if a spring jump is activated this value is greater than 0


func _ready() -> void:
	pass

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
		BEAM_COLOR = area.get_color()
	elif area is Spikes:
		call_deferred("player_dead")
	elif area is Goal:
		emit_signal("levelcleared")
	elif area.get_parent() is Lava:
		ON_LAVA += 1
		if ON_LAVA == 1:
			LAVA1 = area
		else:
			LAVA2 = area
	elif area.get_parent() is Car:
		call_deferred("player_dead")


func _on_Deathcollision_area_exited(area: Area2D) -> void:
	if area is LaserBeam:
		ON_BEAM = false
		BEAM_COLOR = null
	if area.get_parent() is Lava:
		ON_LAVA -= 1
		if ON_LAVA == 0:
			LAVA1 = null
		elif ON_LAVA == 1:
			LAVA1 = LAVA2
			LAVA2 = null


func play_music(level: String):
	if level == "tutorial":
		return
	else:
		if get_parent().SETTINGS[1]:
			$level_music.play(0.0)


func player_dead():
	get_node("Hitbox").disabled = true
	DEAD = true
	if get_parent().SETTINGS[2]:
		$death.play()
	emit_signal("playerdead")


func play_death_animation():
	$player_sprite.play(PLAYER_COLOR + " dead")


func check_if_dead():
	if ON_BEAM and PLAYER_COLOR != BEAM_COLOR:
		call_deferred("player_dead")
	if ON_LAVA == 1:
		if LAVA1.get_parent().COLOR == PLAYER_COLOR:
			call_deferred("player_dead")
	if ON_LAVA == 2:
		if LAVA1.get_parent().COLOR == PLAYER_COLOR or LAVA2.get_parent().COLOR == PLAYER_COLOR:
			call_deferred("player_dead")


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
	$ParallaxBackground/background.play(level)

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
