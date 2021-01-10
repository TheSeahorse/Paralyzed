extends Node

const CHUNK_0 = preload("res://Source/Levels/Endless/endless_template.tscn")

var CHUNK_NR = 0
var CHUNK_LENGTH = 1600
var SETTINGS

# Called when the node enters the scene tree for the first time.
func _ready():
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
	print(str(player.position.x) + str(player.position.y))
	if player.position.x > (((CHUNK_NR - 1) * CHUNK_LENGTH) - 200):
		print(CHUNK_NR)
		spawn_chunk()
		despawn_chunk()


func spawn_chunk():
	var chunk = load("res://Source/Levels/Endless/endless_template.tscn").instance()
	add_child(chunk)
	chunk.position = Vector2(CHUNK_NR * CHUNK_LENGTH, 0)
	CHUNK_NR += 1


func despawn_chunk():
	get_child(0).queue_free()


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
