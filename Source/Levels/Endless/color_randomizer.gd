extends Node2D


#don't turn on if there are more than 4 enemies
export var all_diff: bool
export var all_same: bool
export var same_range: int
var RNG
var PLAYER_COLOR
var COLORS = ["cyan", "red", "purple", "yellow"]


func _ready():
	RNG = get_parent().get_parent().RNG
	PLAYER_COLOR = get_parent().get_parent().player.PLAYER_COLOR
	if all_diff:
		all_different()
	else:
		all_random()


#will give the rest cyan if more than 4 colors
func all_different():
	for child in get_children():
		if (child is Square) or (child is LaserBeam) or (child is Lava) or (child is Car):
			if COLORS.size() < 1:
				child.change_color("cyan", PLAYER_COLOR)
			else:
				var index = RNG.randi_range(0, COLORS.size() - 1)
				child.change_color(COLORS[index], PLAYER_COLOR)
				COLORS.remove(index)
				


func all_random():
	for child in get_children():
		if (child is Square) or (child is LaserBeam) or (child is Lava) or (child is Car):
			child.change_color(COLORS[RNG.randi_range(0, 3)], PLAYER_COLOR)
