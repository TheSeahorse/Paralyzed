extends Actor
class_name Player
signal levelcleared
signal playerdead

var PLAYER_COLOR: = "cyan"
var ON_HEADS: = 0 # the amount of enemy heads the player is currently on
var ON_LAVA: = 0 # the amount of lava tiles the player is currently on
var ON_BEAM: = false # true if player is currently on a beam
var BEAM_COLOR # color of the beam the player is on
var LAVA1 # left most lava tile the player is on (if on only one tile this var is used)
var LAVA2 # right most lava tile the player is on (only if player is on two tiles)
var SPRING_JUMP: = 0 # if a spring jump is activated this value is greater than 0

func _physics_process(delta: float) -> void:
	check_if_dead()
	VELOCITY.x = MAX_SPEED.x
	VELOCITY = calculate_y(VELOCITY, delta)
	VELOCITY = move_and_slide(VELOCITY, FLOOR_NORMAL)


func _on_enemy_head_entered(body: Node) -> void:
	if body is Square and body.ON_FLOOR: 
		ON_HEADS += 1
		


func _on_enemy_head_body_exited(body: Node) -> void:
	if body is Square:
		ON_HEADS -= 1


func _on_Deathcollision_area_entered(area: Area2D) -> void:
	if area is LaserBeam:
		ON_BEAM = true
		BEAM_COLOR = area.get_color()
	elif area is Spikes:
		emit_signal("playerdead")
	elif area is Goal:
		emit_signal("levelcleared")
	elif area.get_parent() is Lava:
		ON_LAVA += 1
		if ON_LAVA == 1:
			LAVA1 = area
		elif ON_LAVA == 2:
			LAVA2 = area
	elif area.get_parent() is Car:
		emit_signal("playerdead")


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


func check_if_dead():
	if ON_BEAM and PLAYER_COLOR != BEAM_COLOR:
		emit_signal("playerdead")
	if ON_LAVA == 1:
		if LAVA1.get_parent().COLOR == PLAYER_COLOR:
			emit_signal("playerdead")
	if ON_LAVA == 2:
		if LAVA1.get_parent().COLOR == PLAYER_COLOR or LAVA2.get_parent().COLOR == PLAYER_COLOR:
			emit_signal("playerdead")


func calculate_y(velocity: Vector2, delta: float) -> Vector2:
	if ON_HEADS > 0 and SPRING_JUMP == 10:
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


func is_color(color: String):
	$player_sprite.play(color)
	PLAYER_COLOR = color
