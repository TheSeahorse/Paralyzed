extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_released("action"):
		reset()
	elif Input.is_action_just_released("escape"):
		back()


func reset():
	get_tree().paused = false
	get_parent().remove_player_and_level()
	get_parent().play_level("endless", false)
	self.queue_free()


func back():
	get_tree().paused = false
	get_parent().remove_player_and_level()
	get_parent().mainmenu.show_level_menu()
	if get_parent().SETTINGS[1]:
		get_parent().mainmenu.start_music()
	self.queue_free()


func _on_back_button_pressed():
	back()


func _on_retry_button_pressed():
	reset()
