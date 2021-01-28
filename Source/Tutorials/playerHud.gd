extends CanvasLayer


var NO_PAUSE_TIME = 0


func _ready() -> void:
	$qwer/cyan.set_text(InputMap.get_action_list("cyan")[0].as_text())
	$qwer/red.set_text(InputMap.get_action_list("red")[0].as_text())
	$qwer/purple.set_text(InputMap.get_action_list("purple")[0].as_text())
	$qwer/yellow.set_text(InputMap.get_action_list("yellow")[0].as_text())


func _process(_delta):
	if NO_PAUSE_TIME == 1:
		$no_pause.hide()
		NO_PAUSE_TIME -= 1
	elif NO_PAUSE_TIME > 1:
		NO_PAUSE_TIME -= 1


func hud_update_endless_score(score: int):
	if score < 0:
		$score.set_text("Score: 0")
	else:
		$score.set_text("Score: " + str(score))


func show_score():
	$score.show()


func show_no_pause():
	$no_pause.show()
	NO_PAUSE_TIME = 30
