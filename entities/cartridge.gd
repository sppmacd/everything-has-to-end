extends StaticBody2D

@export
var key_to_display: String

func action_tooltip() -> String:
	return "Press E to view the cartridge"

func action_enabled() -> bool:
	return true

func action_use(player: Player):
	var cartridge_ui = preload("res://gui/cartridge_ui.tscn").instantiate()
	
	cartridge_ui.set_key(key_to_display)
	Main.the.add_ui(cartridge_ui)
	
