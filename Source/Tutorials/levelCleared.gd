extends CanvasLayer

func _ready() -> void:
	calculate_deaths()
	calculate_time()


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_released("action"):
		get_tree().paused = false
		get_parent().player_cleared_level()
		self.queue_free()


func calculate_deaths():
	var total_deaths = 0
	for death in get_parent().DEATHS:
		total_deaths += death
	$totaldeaths.text = "Total deaths: " + str(total_deaths + get_parent().CURRENT_DEATHS)
	$deaths.text = "Deaths: " + str(get_parent().CURRENT_DEATHS)


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
	$timespent.text = "Time: " + str_minutes + ":" + str_seconds
