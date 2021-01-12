extends Node

const CHUNK_0 = preload("res://Source/Levels/Endless/empty.tscn")

var CHUNK_NR = 0 #what chunk we're currently on, always three chunks live, you're on one, one behind and one infront, the rest should free up.
var CHUNK_LENGTH = 1600
var SETTINGS # copied from main onload
var RNG # copied from main onload


# Called when the node enters the scene tree for the first time.
func _ready():
	RNG = get_parent().RNG
	SETTINGS = get_parent().SETTINGS
	var chunk_pre = CHUNK_0.instance()
	var chunk_0 = CHUNK_0.instance()
	add_child(chunk_pre)
	add_child(chunk_0)
	chunk_pre.position = Vector2(-1 * CHUNK_LENGTH, 0)
	chunk_0.position = Vector2(0,0)
	CHUNK_NR = 1
	spawn_chunk()


func _process(_delta):
	var player = get_parent().player
	if player.position.x > (((CHUNK_NR - 1) * CHUNK_LENGTH)):
		spawn_chunk()
		despawn_chunk()
	get_parent().update_endless_score(CHUNK_NR - 3)


func spawn_chunk():
	var name = decide_chunk()
	var chunk = load("res://Source/Levels/Endless/" + name).instance()
	chunk.position = Vector2(CHUNK_NR * CHUNK_LENGTH, 0)
	add_child(chunk)
	CHUNK_NR += 1


func despawn_chunk():
	get_child(0).queue_free()


# increasing difficulty every 5 scores (starts at 6 since you don't get anything for the first blank chunk)
func decide_chunk() -> String:
	var difficulty: String
	var rand: int
	if CHUNK_NR < 6:
		difficulty = "Easy"
	elif CHUNK_NR < 11:
		if RNG.randi_range(0,2) > 0:
			difficulty = "Easy"
		else:
			difficulty = "Moderate"
	elif CHUNK_NR < 16:
		if RNG.randi_range(0,2) > 1:
			difficulty = "Easy"
		else:
			difficulty = "Moderate"
	elif CHUNK_NR < 21:
		rand = RNG.randi_range(0,5)
		if rand > 4:
			difficulty = "Easy"
		elif rand > 1:
			difficulty = "Moderate"
		else:
			difficulty = "Hard"
	elif CHUNK_NR < 26:
		if RNG.randi_range(0,3) > 1:
			difficulty = "Moderate"
		else:
			difficulty = "Hard"
	elif CHUNK_NR < 31:
		rand = RNG.randi_range(0,9)
		if rand > 6:
			difficulty = "Moderate"
		elif rand > 0:
			difficulty = "Hard"
		else:
			difficulty = "Insanity"
	elif CHUNK_NR < 36:
		rand = RNG.randi_range(0,9)
		if rand > 8:
			difficulty = "Moderate"
		elif rand > 2:
			difficulty = "Hard"
		else:
			difficulty = "Insanity"
	elif CHUNK_NR < 41:
		if RNG.randi_range(0,3) > 1:
			difficulty = "Hard"
		else:
			difficulty = "Insanity"
	elif CHUNK_NR < 46:
		if RNG.randi_range(0,2) > 1:
			difficulty = "Hard"
		else:
			difficulty = "Insanity"
	elif CHUNK_NR < 51:
		if RNG.randi_range(0,7) > 6:
			difficulty = "Hard"
		else:
			difficulty = "Insanity"
	else:
		difficulty = "Insanity"
	var chunk_name = get_chunk_name(difficulty)
	print(CHUNK_NR)
	print(chunk_name)
	print("============================")
	return chunk_name


# Easy, Moderate, Hard, Insanity
func get_chunk_name(difficulty: String) -> String:
	var files = list_files_in_directory("res://Source/Levels/Endless/" + difficulty)
	var scene = files[RNG.randi_range(0, files.size() - 1)]
	return difficulty + "/" + scene


# gets all files in a directory as a list
func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)
	dir.list_dir_end()
	return files


func action(color: String):
	for chunk in get_children():
		for child in chunk.get_children():
			if child is Square and color == child.COLOR:
				child.action()
			if child is Car and color == child.COLOR:
				child.TOGGLE_ACTION = true


func play_animation(color: String):
	for chunk in get_children():
		for child in chunk.get_children():
			if child is LaserBeam:
				if child.COLOR == color:
					child.fade_out()
				else:
					child.fade_in()
			elif child is Lava:
				if child.COLOR == color:
					child.turn_on()
				else:
					child.turn_off()


func add_stat(stat: String, amount:int):
	get_parent().add_stat(stat, amount)


func kill_player(cause: String, color: String):
	get_parent().kill_player(cause, color)
