extends Actor
class_name Player
signal levelcleared
signal playerdead

var PLAYER_COLOR: = "cyan"
var ON_HEADS: = 0 #the amount of enemy heads the player is currently on
var SPRING_JUMP: = 0 #if a spring jump is activated this value is greater than 0

func _physics_process(delta: float) -> void:
	VELOCITY.x = MAX_SPEED.x
	VELOCITY = calculate_y(VELOCITY, delta)
	VELOCITY = move_and_slide(VELOCITY, FLOOR_NORMAL)


func _on_enemy_head_entered(body: Node) -> void:
	if body is Square and body.ON_FLOOR: # OBS KOMMER TROLIGEN LEDA TILL BUGGAR DÄR ON_HEADS BLIR NEGATIVT
		ON_HEADS += 1


func _on_enemy_head_body_exited(body: Node) -> void:
	if body is Square:
		ON_HEADS -= 1


func _on_area2D_area_entered(area: Area2D) -> void:
	if area is LaserBeam and area.get_color() != PLAYER_COLOR:
		emit_signal("playerdead")
	elif area is Spikes:
		emit_signal("playerdead")
	elif area is Goal:
		emit_signal("levelcleared")


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






