extends Actor
class_name Car

export var COLOR: = "cyan"
var ENABLED: = false # turns true the first time physics process is called
var TOGGLE_ACTION: = false #if "action" has been input by the user
var ON_FLOORS: = 0 #if the square is on any kind of KinematicBody2D
var ON_LAVA: = false
var LAVA
var ON_LASER: = false
var LASER
var DEAD: = false
var DEATH_COUNTDOWN: = 0

func _ready() -> void:
	$car_sprite.play(COLOR)
	set_physics_process(false)


func _process(_delta: float) -> void:
	if DEATH_COUNTDOWN != 0:
		if DEATH_COUNTDOWN == 1:
			self.queue_free()
		else:
			DEATH_COUNTDOWN -= 1
	if ON_LAVA and LAVA.BURNING:
		car_dead()
	if ON_LASER and LASER.BEAMING:
		car_dead()


func _physics_process(delta: float) -> void:
	if !ENABLED:
		TOGGLE_ACTION = false
		ENABLED = true
	if TOGGLE_ACTION:
		jump()
	if DEAD:
		VELOCITY = Vector2(0, 0)
	else:
		VELOCITY.x =- MAX_SPEED.x
		VELOCITY = calculate_move_velocity(VELOCITY, delta)
	VELOCITY = move_and_slide(VELOCITY, FLOOR_NORMAL)


func change_color(color: String, _player_color: String):
	COLOR = color
	$car_sprite.play(color)


func car_dead():
	if !DEAD:
		if get_parent().get_parent().SETTINGS[2]:
			$death.play()
		$CollisionShape2D.queue_free()
		$Area2D.queue_free()
		$hitbox.queue_free()
		$car_sprite.play(COLOR + " death")
		DEATH_COUNTDOWN = 80
		get_parent().get_parent().add_stat("car-killed", 1)
	DEAD = true


func calculate_move_velocity(linear_velocity: Vector2, delta: float) -> Vector2:
	linear_velocity.y += GRAVITY * delta
	return linear_velocity


func jump() -> void:
	TOGGLE_ACTION = false
	if ON_FLOORS > 0:
		if get_parent().get_parent().SETTINGS[2]:
			$jump.play()
		get_parent().get_parent().add_stat("car-jump", 1)
		VELOCITY.y =- MAX_SPEED.y * 1.2
		ON_FLOORS -= 1


func _on_Area2D_body_entered(body: Node) -> void:
	if body is TileMap:
		ON_FLOORS += 1


func _on_Area2D_body_exited(body: Node) -> void:
	if body is TileMap:
		if ON_FLOORS > 0:
			ON_FLOORS -= 1


func _on_hitbox_area_entered(area: Area2D) -> void:
	if area is LaserBeam and (area.COLOR != COLOR):
		ON_LASER = true
		LASER = area
	elif area.get_parent() is Lava and (area.get_parent().COLOR != COLOR):
		ON_LAVA = true
		LAVA = area.get_parent()


func _on_hitbox_area_exited(area: Area2D) -> void:
	if area is LaserBeam and (area.COLOR != COLOR):
		ON_LASER = false
	elif area.get_parent() is Lava and (area.get_parent().COLOR != COLOR):
		ON_LAVA = false
