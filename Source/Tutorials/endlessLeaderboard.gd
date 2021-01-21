extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_released("action"):
		get_tree().paused = false
		get_parent().remove_player_and_level()
		get_parent().play_level("endless", false)
		self.queue_free()
	elif Input.is_action_just_released("escape"):
		get_tree().paused = false
		get_parent().remove_player_and_level()
		get_parent().mainmenu.show_level_menu()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		if get_parent().SETTINGS[1]:
			get_parent().mainmenu.start_music()
		self.queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
