extends CanvasLayer


var ENTRIES: Array


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_released("action"):
		reset()
	elif Input.is_action_just_released("escape"):
		back()


func show_leaderboard():
	$loading.hide()
	$leaderboard.show()


func display_user_leaderboard(leaderboard: Array):
	var username = Steam.getFriendPersonaName(leaderboard[0].steamID)
	$leaderboard/HBoxContainer13/placement.set_text(str(leaderboard[0].global_rank) + ". ")
	$leaderboard/HBoxContainer13/username.set_text(username)
	$leaderboard/HBoxContainer13/score.set_text(str(leaderboard[0].score))
	$leaderboard/HBoxContainer13/attempts.set_text(set_attempts_label(leaderboard[0].details[0]))
	$loading.hide()
	$leaderboard.show()


func receive_display_leaderboard(leaderboard: Array):
	ENTRIES = leaderboard
	var counter = 0
	for node in $leaderboard.get_children():
		if ENTRIES.size() < counter:
			break
		if node is HBoxContainer:
			if counter == 0: #this skips the header
				counter += 1
			else:
				var name_label = get_node("leaderboard/HBoxContainer" + str(counter) + "/username")
				var score_label = get_node("leaderboard/HBoxContainer" + str(counter) + "/score")
				var attempts_label = get_node("leaderboard/HBoxContainer" + str(counter) + "/attempts")
				var username = Steam.getFriendPersonaName(ENTRIES[counter - 1].steamID)
				name_label.set_text(username)
				score_label.set_text(str(ENTRIES[counter - 1].score))
				attempts_label.set_text(set_attempts_label(ENTRIES[counter - 1].details[0]))
				counter += 1


func offline():
	$loading.hide()
	$offline.show()


func set_attempts_label(attempts: int):
	if attempts < 10:
		return "       " + str(attempts) + "  "
	elif attempts < 100:
		return "      " + str(attempts) + "  "
	elif attempts < 1000:
		return "     " + str(attempts) + "  "
	elif attempts < 10000:
		return "    " + str(attempts) + "  "
	elif attempts < 100000:
		return "   " + str(attempts) + "  "
	elif attempts < 1000000:
		return "  " + str(attempts) + "  "
	elif attempts < 10000000:
		return " " + str(attempts) + "  "
	else:
		return " 9999999  "


func reset():
	get_parent().play_level("endless", false)
	get_parent().mainmenu.stop_music()
	self.queue_free()


func back():
	get_parent().mainmenu.show_level_menu()
	self.queue_free()


func _on_back_button_pressed():
	get_parent().click()
	back()


func _on_retry_button_pressed():
	get_parent().click()
	reset()
