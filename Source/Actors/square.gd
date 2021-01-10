extends Actor
class_name Square

export var COLOR: = "cyan"
var PLAYER_OVER: = false #true if the player is over
var ENABLED: = false #turns true the first time physics process is run
var GRACE_FRAMES: = 0 #how many frames the player can miss the jump on a square (if its in the air) but the square still jumps
var TOGGLE_ACTION: = false #if "action" has been input by the user
var ON_FLOOR: = false #if the square is on any kind of KinematicBody2D
var SPRING_JUMP: = 0 #variable to control the flingy jump of the square, if greater than 0 we're calculating the jump
var ON_LAVA: = false
var LAVA
var DEAD: = false
var DEATH_COUNTDOWN: = 0


func _ready() -> void:
	$square_sprite.play(COLOR)
	set_physics_process(false)


func _process(_delta: float) -> void:
	if DEATH_COUNTDOWN != 0:
		if DEATH_COUNTDOWN == 1:
			self.queue_free()
		else:
			DEATH_COUNTDOWN -= 1
	if ON_LAVA:
		if (LAVA.COLOR != COLOR) and LAVA.BURNING:
			square_dead()


func _physics_process(delta: float) -> void:
	if !ENABLED:
		TOGGLE_ACTION = false
		ENABLED = true
	if TOGGLE_ACTION:
		calculate_jump()
	if !DEAD:
		VELOCITY = calculate_move_velocity(VELOCITY, delta)
		VELOCITY = move_and_slide(VELOCITY, FLOOR_NORMAL)


func change_color(color: String, _player_color: String):
	COLOR = color
	$square_sprite.play(color)


func square_dead():
	if !DEAD:
		if get_parent().get_parent().SETTINGS[2]:
			$death.play()
		$spikes.queue_free()
		$spikes2.queue_free()
		$spikes3.queue_free()
		$CollisionShape2D.disabled = true
		$square_sprite.play(COLOR + " death")
		DEATH_COUNTDOWN = 20
		get_parent().get_parent().add_stat("square-killed", 1)
	DEAD = true


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


func _on_floor_detector_body_entered(body: Node) -> void:
	if body is TileMap and !ON_FLOOR:
		ON_FLOOR = true


func _on_floor_detector_body_exited(body: Node) -> void:
	if body is TileMap:
		ON_FLOOR = false #this gets changed faster in the jump functions


func _on_floor_detector_area_entered(area: Area2D) -> void:
	if area.get_parent() is Lava:
		ON_LAVA = true
		LAVA = area.get_parent()
	elif area.get_parent() is Car:
		if area.get_parent().COLOR != COLOR:
			call_deferred("square_dead")


func _on_floor_detector_area_exited(area: Area2D) -> void:
	if area.get_parent() is Lava:
		ON_LAVA = false
