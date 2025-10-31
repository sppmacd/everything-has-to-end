extends Node2D

func target() -> Node2D:
	return get_node("Target")

func action_use(player: Player):
	player.position = target().global_position
