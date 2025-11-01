extends Door

func _on_set_open(open: bool):
	collision_layer = 0x2 if open else 0x3
