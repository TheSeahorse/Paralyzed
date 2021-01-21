extends CanvasLayer

func _ready() -> void:
	$qwer/cyan.set_text(InputMap.get_action_list("cyan")[0].as_text())
	$qwer/red.set_text(InputMap.get_action_list("red")[0].as_text())
	$qwer/purple.set_text(InputMap.get_action_list("purple")[0].as_text())
	$qwer/yellow.set_text(InputMap.get_action_list("yellow")[0].as_text())


func hud_update_endless_score(score: int):
	if score < 0:
		$score.set_text("Score: 0")
	else:
		$score.set_text("Score: " + str(score))


func show_score():
	$score.show()
