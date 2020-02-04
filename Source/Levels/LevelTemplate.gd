extends Node

func action():
	for child in get_children():
		if child is Actor: 
			if child.SAME_COLOR:
				child.TOGGLE_ACTION = true

func turn_on_cyan():
	for child in get_children():
		if child.has_method("is_cyan"):
			child.turn_on()
		elif child is Actor:
			child.turn_off()


func turn_on_red():
	for child in get_children():
		if child.has_method("is_red"):
			child.turn_on()
		elif child is Actor:
			child.turn_off()


func turn_on_purple():
	for child in get_children():
		if child.has_method("is_purple"):
			child.turn_on()
		elif child is Actor:
			child.turn_off()


func turn_on_yellow():
	for child in get_children():
		if child.has_method("is_yellow"):
			child.turn_on()
		elif child is Actor:
			child.turn_off()
