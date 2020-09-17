extends Area2D
signal spawnTutorial

export var tutorial_name = "" #name of the tutorial you want to popup

func _ready() -> void:
	connect("spawnTutorial", get_parent().get_parent(), "display_popup")

func _on_popup_body_entered(body: Node) -> void:
	if body is Player:
		emit_signal("spawnTutorial", tutorial_name)
