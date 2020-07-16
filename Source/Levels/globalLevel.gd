extends Node
class_name GlobalLevel

func action(color: String):
	for child in get_children():
		if child is Square and color == child.COLOR:
			child.TOGGLE_ACTION = true
		if child is Car and color == child.COLOR:
			child.TOGGLE_ACTION = true

func play_animation(color: String):
	for child in get_children():
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
