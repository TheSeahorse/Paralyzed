extends Node

func action(color: String):
	for child in get_children():
		if child is Actor and color == child.COLOR: 
			print("toggle")
			child.TOGGLE_ACTION = true
