extends CanvasLayer

func _ready() -> void:
	$qwer/cyan.set_text(InputMap.get_action_list("cyan")[0].as_text())
	$qwer/red.set_text(InputMap.get_action_list("red")[0].as_text())
	$qwer/purple.set_text(InputMap.get_action_list("purple")[0].as_text())
	$qwer/yellow.set_text(InputMap.get_action_list("yellow")[0].as_text())
