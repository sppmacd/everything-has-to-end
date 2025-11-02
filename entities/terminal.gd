extends StaticBody2D

var checked: bool = false

func action_tooltip() -> String:
	return "Press E to hack a chip"

func action_enabled() -> bool:
	return not checked

func action_use(_player: Player):
	if checked:
		return
	checked = true
	$Sprite2D.region_rect.position.x = 48.0

	Main.the.set_new_checkpoint()
