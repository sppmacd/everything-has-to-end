extends Node2D

signal use(player: Player)

@export
var required_key: String

func set_required_key(rk: String):
	required_key = rk

func target() -> Node2D:
	return get_node_or_null("Target")

func action_use(player: Player):
	if required_key and not player.has_key(required_key):
		print("requires key ", required_key)
		return
	if target():
		player.position = target().global_position
	use.emit(player)

func action_tooltip() -> String:
	return "Press E to go through"

func action_enabled() -> bool:
	return true
