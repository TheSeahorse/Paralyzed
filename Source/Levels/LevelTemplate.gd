extends Node

func action(color: String):
	for child in get_children():
		if child is Actor and color == child.COLOR: 
			child.TOGGLE_ACTION = true
