extends CanvasLayer

var FIREWORK_DELAY: int = 50 #delay for fireworks
var CLEAR_SCREEN_DELAY: int = 340 #dealy for clear text
var UNLOCK_AMOUNT # how many levels we unlocked 1 or 2. if 3 we beat the game

func _ready() -> void:
	randomize_firework_position()
	randomize_clear_message()
	calculate_deaths()
	calculate_time()
	calculate_levels_unlocked()
	$Sprite/continue_label.set_text("press " + InputMap.get_action_list("action")[0].as_text() + " to save & continue")
	play_sound("confetti")
	if get_parent().SETTINGS[1]:
		$clear_loop.play()


func _process(_delta):
	clear_text_counter()
	firework_counter()


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_released("action") and CLEAR_SCREEN_DELAY < 260:
		get_tree().paused = false
		get_parent().player_cleared_level()
		self.queue_free()


func firework_counter():
	if FIREWORK_DELAY == 0:
		$Particles2D2.restart()
		FIREWORK_DELAY -= 1
	if FIREWORK_DELAY == 43:
		$Particles2D.restart()
		FIREWORK_DELAY -= 1
	elif FIREWORK_DELAY > 0:
		FIREWORK_DELAY -= 1

#pops the messages one by one and only the last two if unlocked levels is 1 or 2
func clear_text_counter():
	if (CLEAR_SCREEN_DELAY == 0) and (UNLOCK_AMOUNT == 2):
		play_sound("pop")
		$Sprite/level2.show()
		CLEAR_SCREEN_DELAY -= 1
	elif (CLEAR_SCREEN_DELAY == 40) and (UNLOCK_AMOUNT > 0):
		play_sound("pop")
		if UNLOCK_AMOUNT == 1:
			$Sprite/level3.show()
		elif UNLOCK_AMOUNT == 2:
			$Sprite/level1.show()
		CLEAR_SCREEN_DELAY -= 1
	elif CLEAR_SCREEN_DELAY == 120:
		if UNLOCK_AMOUNT == 0:
			play_sound("pop")
		elif UNLOCK_AMOUNT == 3:
			play_sound("game_completed")
		else:
			play_sound("levels_unlocked")
		$Sprite/levels_unlocked.show()
		CLEAR_SCREEN_DELAY -= 1
	elif CLEAR_SCREEN_DELAY == 180:
		play_sound("pop")
		$Sprite/timespent.show()
		CLEAR_SCREEN_DELAY -= 1
	elif CLEAR_SCREEN_DELAY == 220:
		play_sound("pop")
		$Sprite/deaths_total.show()
		CLEAR_SCREEN_DELAY -= 1
	elif CLEAR_SCREEN_DELAY == 260:
		play_sound("pop")
		$Sprite/continue_label.show()
		$Sprite/deaths_attempt.show()
		CLEAR_SCREEN_DELAY -= 1
	elif CLEAR_SCREEN_DELAY > 0:
		CLEAR_SCREEN_DELAY -= 1


func play_sound(name: String):
	if get_parent().SETTINGS[2]:
		get_node(name).play()

 
func calculate_levels_unlocked():
	var node = get_node("Sprite/levels_unlocked")
	var level_number = get_parent().LEVEL_ORDER.find(get_parent().CURRENT_LEVEL)
	var cleared_level = get_parent().LEVELS_CLEARED[level_number][0]
	if level_number == 0:
		levels_unlocked_color_to_white()
		node.set_text("tutorial completed!\ngood luck!")
		UNLOCK_AMOUNT = 0
	elif get_parent().PRACTICE:
		levels_unlocked_color_to_white()
		node.set_text("practice completed!\nbeat the real level!")
		UNLOCK_AMOUNT = 0
	elif cleared_level:
		levels_unlocked_color_to_white()
		node.set_text("you already beat\nthis level")
		UNLOCK_AMOUNT = 0
	else:
		UNLOCK_AMOUNT = decide_unlocked_levels(level_number)


#returns the amount of unlocked levels and modifies the level labels inside Sprite
func decide_unlocked_levels(number: int) -> int:
	var levels = ["none", "level1", "cube-2", "cube-3", "cube-4", "laser-1", "laser-2", "laser-3", "laser-4", "fire-1", "fire-2", "fire-3", "fire-4", "car-1", "car-2", "car-3", "car-4", "all-1", "all-2", "all-3", "finale"]
	var world = ["none", "cube", "laser", "fire", "car"]
	var cleared = get_parent().LEVELS_CLEARED
	if !get_parent().PRACTICE:
		cleared[number][0] = true
	match number:
		1, 5, 9, 13:
			$Sprite/level1.set_text(levels[number+1])
			$Sprite/level2.set_text(levels[number+4])
			$Sprite/levels_unlocked.set_text("levels unlocked!")
			return 2
		2, 6, 10, 14:
			if cleared[2][0] and cleared[6][0] and cleared[10][0] and cleared[14][0] and cleared[17][0]:
				$Sprite/level1.set_text(levels[number+1])
				$Sprite/level2.set_text("all-2")
				$Sprite/levels_unlocked.set_text("levels unlocked!")
				return 2
			else:
				$Sprite/level3.set_text(levels[number+1])
				$Sprite/levels_unlocked.set_text("level unlocked!")
				return 1
		3, 7, 11, 15:
			if cleared[3][0] and cleared[7][0] and cleared[11][0] and cleared[15][0] and cleared[18][0]:
				$Sprite/level1.set_text(levels[number+1])
				$Sprite/level2.set_text("all-3")
				$Sprite/levels_unlocked.set_text("levels unlocked!")
				return 2
			else:
				$Sprite/level3.set_text(levels[number+1])
				$Sprite/levels_unlocked.set_text("level unlocked!")
				return 1
		4, 8, 12, 16:
			if cleared[4][0] and cleared[8][0] and cleared[12][0] and cleared[16][0] and cleared[19][0]:
				$Sprite/level3.set_text(world[number/4] + " world completed!")
				$Sprite/levels_unlocked.set_text("finale unlocked")
				return 1
			else:
				$Sprite/levels_unlocked.set_text("congratulations!\n" + world[number/4] + " world completed!")
				return 0
		17:
			if cleared[2][0] and cleared[6][0] and cleared[10][0] and cleared[14][0] and cleared[17][0]:
				$Sprite/level1.set_text("all-2")
				$Sprite/levels_unlocked.set_text("level unlocked!")
				return 1
			else:
				levels_unlocked_color_to_white()
				$Sprite/levels_unlocked.set_text("beat more levels\nto unlock all-2")
				return 0
		18:
			if cleared[3][0] and cleared[7][0] and cleared[11][0] and cleared[15][0] and cleared[18][0]:
				$Sprite/level1.set_text("all-3")
				$Sprite/levels_unlocked.set_text("level unlocked!")
				return 1
			else:
				levels_unlocked_color_to_white()
				$Sprite/levels_unlocked.set_text("beat more levels\nto unlock all-3")
				return 0
		19:
			if cleared[4][0] and cleared[8][0] and cleared[12][0] and cleared[16][0] and cleared[19][0]:
				$Sprite/level1.set_text("finale")
				$Sprite/levels_unlocked.set_text("level unlocked!")
				return 1
			else:
				levels_unlocked_color_to_white()
				$Sprite/levels_unlocked.set_text("beat all levels\to unlock the finale")
				return 0
		20:
			$Sprite/levels_unlocked.set_text("congratulations!!!\nyou beat the game!")
			return 3
	return -1


func levels_unlocked_color_to_white():
	var node = get_node("Sprite/levels_unlocked")
	var font_color = node.get("custom_colors/font_color")
	font_color = Color.white
	node.set("custom_colors/font_color", font_color)


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
	elif minutes > 59:
		str_minutes = 59
	else:
		str_minutes = str(minutes)
	if seconds < 10:
		str_seconds = "0" + str(seconds)
	else:
		str_seconds = str(seconds)
	$Sprite/timespent.text = "Time: " + str_minutes + ":" + str_seconds
