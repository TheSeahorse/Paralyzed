extends Actor
class_name Lava

export var COLOR: = "cyan"
var IS_ON

func _init():
	GRAVITY = 0

func _ready():
	if COLOR == "cyan":
		$sprite.play("cyan on")
	else:
		$sprite.play(COLOR + " off")


func turn_on():
	$sprite.play(COLOR + " on")


func turn_off():
	$sprite.play(COLOR + " off")
