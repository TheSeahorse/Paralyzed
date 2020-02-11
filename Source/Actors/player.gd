extends Actor
class_name Player

var PLAYER_COLOR: = "cyan"
var ON_HEAD: = false
var JUMP_ACTIVATED: = false
var PLAYER_SPRING_JUMP: = 0

func _physics_process(delta: float) -> void:
	VELOCITY.y += GRAVITY * delta
	VELOCITY.x = MAX_SPEED.x
	if JUMP_ACTIVATED and (ON_HEAD or PLAYER_SPRING_JUMP > 0):
		VELOCITY = spring_jump(delta)
	VELOCITY = move_and_slide(VELOCITY, FLOOR_NORMAL)


func _on_enemy_head_entered(body: Node) -> void:
	if body is Square:
		print("player_on_head")
		ON_HEAD = true


func _on_enemy_head_body_exited(body: Node) -> void:
	if body is Square:
		ON_HEAD = false 


func spring_jump(delta: float) -> Vector2:
	var velocity = VELOCITY
	if ON_HEAD:
		velocity.y = -1.0 * MAX_SPEED.y * 2 
		PLAYER_SPRING_JUMP = 4
	elif PLAYER_SPRING_JUMP > 0:
		velocity.y += delta 
		PLAYER_SPRING_JUMP -= 1
	else:
		velocity.y += GRAVITY * delta
		JUMP_ACTIVATED = false
	return velocity


func activate_spring_jump():
	if ON_HEAD:
		print("player_jump")
		JUMP_ACTIVATED = true


func is_cyan():
	$player_sprite.play("cyan")
	PLAYER_COLOR = "cyan"

func is_red():
	$player_sprite.play("red")
	PLAYER_COLOR = "red"

func is_purple():
	$player_sprite.play("purple")
	PLAYER_COLOR = "purple"

func is_yellow():
	$player_sprite.play("yellow")
	PLAYER_COLOR = "yellow"
