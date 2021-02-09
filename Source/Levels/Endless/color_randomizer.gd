extends Node2D

export var ALL_DIFF: bool #don't turn on if there are more than 4 enemies
export var ALL_SAME: bool
export var SAME_RANGE: int #if all diff on then same range means that the groups are totally random, 
						   #if all same is on then the groups will be different from each other, 
						   #but the total amount of items can't be greater than same_range*4
var RNG = RandomNumberGenerator.new()
var PLAYER_COLOR
var FIXED_COLORS = ["cyan", "red", "purple", "yellow"] #don't modify this one
var COLORS = ["cyan", "red", "purple", "yellow"]
var CURRENT_COLOR = "none"
var LEFT: int


func _ready():
	RNG.randomize()
	PLAYER_COLOR = get_parent().get_parent().player.PLAYER_COLOR
	if ALL_DIFF:
		all_different()
	elif ALL_SAME:
		all_same()
	else:
		all_random()


func all_different():
	for child in get_children():
		if (child is Square) or (child is LaserBeam) or (child is Lava) or (child is Car):
			var index = RNG.randi_range(0, COLORS.size() - 1)
			child.change_color(COLORS[index], PLAYER_COLOR)
			COLORS.remove(index)


func all_same():
	LEFT = SAME_RANGE
	for child in get_children():
		if (child is Square) or (child is LaserBeam) or (child is Lava) or (child is Car):
			if SAME_RANGE == 0:
				all_same_no_intervals(child)
			else:
				all_same_intervals(child)


func all_same_no_intervals(child: Node):
	if CURRENT_COLOR == "none":
		var index = RNG.randi_range(0, COLORS.size() - 1)
		CURRENT_COLOR = COLORS[index]
		child.change_color(COLORS[index], PLAYER_COLOR)
	else:
		child.change_color(CURRENT_COLOR, PLAYER_COLOR)


func all_same_intervals(child: Node):
	if CURRENT_COLOR == "none" or LEFT == 0:
		var index = RNG.randi_range(0, COLORS.size() - 1)
		CURRENT_COLOR = COLORS[index]
		child.change_color(COLORS[index], PLAYER_COLOR)
		COLORS.remove(index)
		if LEFT < 1:
			LEFT = SAME_RANGE - 1
		else:
			LEFT -= 1
	else:
		child.change_color(CURRENT_COLOR, PLAYER_COLOR)
		LEFT -= 1


func all_random():
	for child in get_children():
		if (child is Square) or (child is LaserBeam) or (child is Lava) or (child is Car):
			if SAME_RANGE == 0:
				child.change_color(COLORS[RNG.randi_range(0, 3)], PLAYER_COLOR)
			else:
				all_random_intervals(child)


func all_random_intervals(child: Node):
	if CURRENT_COLOR == "none" or LEFT == 0:
		var index = RNG.randi_range(0, COLORS.size() - 1)
		CURRENT_COLOR = COLORS[index]
		child.change_color(COLORS[index], PLAYER_COLOR)
		if LEFT < 1:
			LEFT = SAME_RANGE - 1
		else:
			LEFT -= 1
	else:
		child.change_color(CURRENT_COLOR, PLAYER_COLOR)
		LEFT -= 1
