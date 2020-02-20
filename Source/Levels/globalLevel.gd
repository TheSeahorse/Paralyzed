extends Node
class_name GlobalLevel

func action(color: String):
	for child in get_children():
		if child is Actor and color == child.COLOR: 
			child.TOGGLE_ACTION = true

func play_animation(color: String):
	for child in get_children():
		if child is LaserBeam:
			if child.COLOR == color:
				child.play_anim()
			else:
				child.stop_anim()
