extends Actor
class_name Car

export var COLOR: = "cyan"
var ENABLED: = false # turns true the first time physics process is called
var TOGGLE_ACTION: = false #if "action" has been input by the user
var ON_FLOOR: = true #if the square is on any kind of KinematicBody2D

func _ready() -> void:
	$car_sprite.play(COLOR)
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	if !ENABLED:
		TOGGLE_ACTION = false
		ENABLED = true
	if TOGGLE_ACTION:
		jump()
	VELOCITY.x =- MAX_SPEED.x
	VELOCITY = calculate_move_velocity(VELOCITY, delta)
	VELOCITY = move_and_slide(VELOCITY, FLOOR_NORMAL)

func calculate_move_velocity(linear_velocity: Vector2, delta: float) -> Vector2:
	linear_velocity.y += GRAVITY * delta
	return linear_velocity


func jump() -> void:
	TOGGLE_ACTION = false
	if ON_FLOOR:
		$jump.play()
		get_parent().get_parent().add_stat("car-jump", 1)
		VELOCITY.y =- MAX_SPEED.y * 1.1
		ON_FLOOR = false


func _on_Area2D_body_exited(body: Node) -> void:
	if body is TileMap:
		ON_FLOOR = false


func _on_Area2D_body_entered(body: Node) -> void:
	if body is LaserBeam and (body.get_parent().COLOR != COLOR):
		self.queue_free()
	if body is Lava and (body.get_parent().COLOR != COLOR):
		self.queue_free()
	if body is TileMap:
		ON_FLOOR = true


func _on_screen_entered() -> void:
	$honk.play()
