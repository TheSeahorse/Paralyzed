extends CanvasLayer

var DELAY: int = 50


func _ready() -> void:
	randomize_firework_position()
	calculate_deaths()
	calculate_time()
	$Sprite/continue_label.set_text("press " + InputMap.get_action_list("action")[0].as_text() + " to save & continue")
	if get_parent().SETTINGS[1]:
		$clear_loop.play()
	if get_parent().SETTINGS[2]:
		$confetti.play()


func _process(delta):
	if DELAY == 0:
		$Particles2D2.restart()
		DELAY -= 1
	if DELAY == 43:
		$Particles2D.restart()
		DELAY -= 1
	elif DELAY > 0:
		DELAY -= 1


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_released("action"):
		get_tree().paused = false
		get_parent().player_cleared_level()
		self.queue_free()


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
	$Sprite/totaldeaths.text = "Total deaths: " + str(total_deaths + get_parent().CURRENT_DEATHS)
	$Sprite/deaths.text = "Deaths: " + str(get_parent().CURRENT_DEATHS)


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
