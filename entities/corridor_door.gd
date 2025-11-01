extends StaticBody2D

var open = false

@export
var required_key: String

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
		collision_layer = 0x3 # Both use and collision
	else:
		open = true
		collision_layer = 0x2 # Only use
