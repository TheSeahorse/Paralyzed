extends CanvasLayer

var DELAY: int = 50
var STALLING_DELAY: int = 340

func _ready() -> void:
	randomize_firework_position()
	randomize_clear_message()
	calculate_deaths()
	calculate_time()
	$Sprite/continue_label.set_text("press " + InputMap.get_action_list("action")[0].as_text() + " to save & continue")
	if get_parent().SETTINGS[1]:
		$clear_loop.play()
	if get_parent().SETTINGS[2]:
		$confetti.play()


func _process(_delta):
	if DELAY == 0:
		$Particles2D2.restart()
		DELAY -= 1
	if DELAY == 43:
		$Particles2D.restart()
		DELAY -= 1
	elif DELAY > 0:
		DELAY -= 1
	if STALLING_DELAY == 0:
		if get_parent().SETTINGS[2]:
			$pop.play()
		$Sprite/level2.show()
		STALLING_DELAY -= 1
	elif STALLING_DELAY == 40:
		if get_parent().SETTINGS[2]:
			$pop.play()
		$Sprite/level1.show()
		STALLING_DELAY -= 1
	elif STALLING_DELAY == 120:
		if get_parent().SETTINGS[2]:
			$levels_unlocked.play()
		$Sprite/levels_unlocked.show()
		STALLING_DELAY -= 1
	elif STALLING_DELAY == 180:
		if get_parent().SETTINGS[2]:
			$pop.play()
		$Sprite/timespent.show()
		STALLING_DELAY -= 1
	elif STALLING_DELAY == 220:
		if get_parent().SETTINGS[2]:
			$pop.play()
		$Sprite/deaths_total.show()
		STALLING_DELAY -= 1
	elif STALLING_DELAY == 260:
		if get_parent().SETTINGS[2]:
			$pop.play()
		$Sprite/deaths_attempt.show()
		STALLING_DELAY -= 1
	elif STALLING_DELAY > 0:
		STALLING_DELAY -= 1


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_released("action"):
		get_tree().paused = false
		get_parent().player_cleared_level()
		self.queue_free()


func randomize_clear_message():
	var rand = get_parent().RNG.randi_range(0, 40)
	var message
	match rand:
		0:
			message = "congrats!"
		1:
			message = "you did it!"
		2:
			message = "level cleared!"
		3:
			message = "incredible!"
		4:
			message = "good job!"
		5:
			message = "great stuff!"
		6:
			message = "how?!"
		7:
			message = "insane!"
		8:
			message = "wow!"
		9:
			message = "no way?!"
		10:
			message = "attaboy!"
		11:
			message = "that's crazy!"
		12:
			message = "my man!"
		13:
			message = "get it girl!"
		14:
			message = "holy moly!"
		15:
			message = "sick moves!"
		16:
			message = "to the next one!"
		17:
			message = "almost done!"
		18:
			message = "godlike!"
		19:
			message = "pro player?!"
		20:
			message = "OH MY GEE!"
		21:
			message = "Cheezuz!"
		22:
			message = "are you a pro?!"
		23:
			message = "hallelujah!"
		24:
			message = "praise the lord!"
		25:
			message = "dayum!"
		26:
			message = "gettem tiger!"
		27:
			message = "level completed!"
		28:
			message = "level obliterated!"
		29:
			message = "crushed it!"
		30:
			message = "my goodness!"
		31:
			message = "finally!"
		32:
			message = "played before?!"
		33:
			message = "what the heck?!"
		34:
			message = "really?!"
		35:
			message = "done!"
		36:
			message = "level done!"
		37:
			message = "wowzerz!"
		38:
			message = "that's incredible!"
		39:
			message = "euphoria!"
		40:
			message = "all hail the king!"
	$Sprite/level_cleared.set_text(message)


func randomize_firework_position():
	var width1 = get_parent().RNG.randi_range(400, 1200)
	var height1 = get_parent().RNG.randi_range(150, 550)
	var width2 = get_parent().RNG.randi_range(400, 1200)
	var height2 = get_parent().RNG.randi_range(150, 550)
	$Particles2D.set_position(Vector2(width1, height1))
	$Particles2D2.set_position(Vector2(width2, height2))


func calculate_deaths():
	var total_deaths = 0
	for deaths in get_parent().DEATHS:
		total_deaths += deaths[0]
		total_deaths += deaths[1]
	total_deaths += get_parent().CURRENT_DEATHS
	if total_deaths > 99999:
		$Sprite/deaths_attempt.text = "Deaths this attempt:99999"
	elif total_deaths > 9999:
		$Sprite/deaths_attempt.text = "Deaths this attempt: " + str(get_parent().CURRENT_DEATHS)
	else:
		$Sprite/deaths_attempt.text = "Deaths this attempt: " + str(get_parent().CURRENT_DEATHS)
	$Sprite/deaths_total.text = "All deaths: " + str(total_deaths)


func calculate_time():
	var str_minutes
	var str_seconds
	var time = OS.get_unix_time() - get_parent().LEVEL_START_TIME
	var minutes = time / 60
	var seconds = time % 60
	if minutes < 10:
		str_minutes = "0" + str(minutes)
	else:
		str_minutes = str(minutes)
	if seconds < 10:
		str_seconds = "0" + str(seconds)
	else:
		str_seconds = str(seconds)
	$Sprite/timespent.text = "Time: " + str_minutes + ":" + str_seconds
