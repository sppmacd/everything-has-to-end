extends Node2D

func target() -> Node2D:
	return get_node("Target")

func action_use(player: Player):
	player.position = target().global_position

func action_tooltip() -> String:
	return "Press E to go up"
