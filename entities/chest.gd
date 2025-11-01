extends StaticBody2D
var opened: bool = false
var initialized: bool = false
var ammo_count: int = 0

func action_tooltip() -> String:
	return "Press E to open"

func action_enabled() -> bool:
	return not opened

func action_use(player: Player):
	if opened:
		return
	opened = true
	$Sprite2D.region_rect.position.x = 48.0
	
	if not initialized:
		ammo_count = randi_range(10, 20)
	
	player.add_ammo(ammo_count)
