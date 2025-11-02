extends StaticBody2D
var used: bool = false

func action_tooltip() -> String:
	return "Press E to use a kit"

func action_enabled() -> bool:
	return not used

func action_use(player: Player):
	if used:
		return
	used = true
	player.heal()
	
	self.visible = false
