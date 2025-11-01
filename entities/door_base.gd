class_name Door
extends StaticBody2D

var open = false: set = set_open

@export
var required_key: String

func set_open(o: bool):
	open = o
	_on_set_open(o)

func _ready():
	_on_set_open(false)

func action_tooltip() -> String:
	var player: Player = Main.the.current_level().player()
	if required_key and not player.has_key(required_key):
		return "Key [img]" + Keys.KEY_TEXTURES[required_key] + "[/img] is required"
	return "Press E to close" if open else "Press E to open"

func action_enabled() -> bool:
	return true

func action_use(player: Player):
	if required_key and not player.has_key(required_key):
		return
	if open:
		open = false
	else:
		open = true

func _on_set_open(_open: bool):
	pass
