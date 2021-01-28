extends CanvasLayer


var ENTRIES


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_released("action"):
		reset()
	elif Input.is_action_just_released("escape"):
		back()


func receive_display_leaderboard(leaderboard: Array):
	ENTRIES = leaderboard
	print(ENTRIES)
	var counter = 0
	for node in $leaderboard.get_children():
		if node is HBoxContainer:
			if counter == 0:
				counter += 1
			else:
				# håller på att hämta och skriva ut leaderboarden
				get_node("leaderboard/" + node.get_name() + "/username").set_text()


func reset():
	get_parent().play_level("endless", false)
	self.queue_free()


func back():
	get_parent().mainmenu.show_level_menu()
	if get_parent().SETTINGS[1]:
		get_parent().mainmenu.start_music()
	self.queue_free()


func _on_back_button_pressed():
	back()


func _on_retry_button_pressed():
	reset()
