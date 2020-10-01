extends Area2D

export var FIXED: = false

func _on_Camera_changer_player_entered(body: Node) -> void:
	if body is Player:
		if FIXED:
			body.get_node("Camera2D").set_drag_margin(MARGIN_TOP, 0)
		else:
			body.get_node("Camera2D").set_drag_margin(MARGIN_TOP, 1)
