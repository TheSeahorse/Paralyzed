extends Actor
class_name Square

export var COLOR: = "cyan"
var PLAYER_OVER: = false #true if the player is over
var ENABLED: = false #turns true the first time physics process is run
var GRACE_FRAMES: = 0 #how many frames the player can miss the jump on a square (if its in the air) but the square still jumps
var TOGGLE_ACTION: = false #if "action" has been input by the user
var ON_FLOOR: = true #if the square is on any kind of KinematicBody2D
var SPRING_JUMP: = 0 #variable to control the flingy jump of the square, if greater than 0 we're calculating the jump

func _ready() -> void:
	$square_sprite.play(COLOR)
	set_physics_process(false)


func _physics_process(delta: float) -> void:
	if !ENABLED:
		TOGGLE_ACTION = false
		ENABLED = true
	if TOGGLE_ACTION:
		calculate_jump()
	VELOCITY = calculate_move_velocity(VELOCITY, delta)
	VELOCITY = move_and_slide(VELOCITY, FLOOR_NORMAL)


func _on_tileMap_body_entered(_body: Node) -> void: #Area2D, not tilemap
	if not ON_FLOOR:
		ON_FLOOR = true


func _on_tileMap_body_exited(_body: Node) -> void: #Area2D, not tilemap
	ON_FLOOR = false #this gets changed faster in the jump functions


func action():
	GRACE_FRAMES = 5
	TOGGLE_ACTION = true


func calculate_jump():
	if GRACE_FRAMES > 0:
		if ON_FLOOR:
			ON_FLOOR = false
			if PLAYER_OVER:
				SPRING_JUMP = 26
			else:
				SPRING_JUMP = 24
			GRACE_FRAMES = 0
			TOGGLE_ACTION = false
			get_parent().get_parent().add_stat("square-jump", 1)
			if get_parent().get_parent().SETTINGS[2]:
				$jump.play()
		else:
			GRACE_FRAMES -= 1
	elif GRACE_FRAMES == 0:
		TOGGLE_ACTION = false
		if ON_FLOOR:
			ON_FLOOR = false
			if PLAYER_OVER:
				SPRING_JUMP = 26
			else:
				SPRING_JUMP = 24
			get_parent().get_parent().add_stat("square-jump", 1)
			if get_parent().get_parent().SETTINGS[2]:
				$jump.play()


func calculate_move_velocity(linear_velocity: Vector2, delta: float) -> Vector2:
	if SPRING_JUMP == 25 or SPRING_JUMP == 26: #stall for two frames if player is over so that the player jump works
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


func _on_player_detector_area_entered(_area: Area2D) -> void:
	PLAYER_OVER = true


func _on_player_detector_area_exited(_area: Area2D) -> void:
	PLAYER_OVER = false
