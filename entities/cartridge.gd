extends StaticBody2D

var discard: bool = false

@export
var key_to_display: String

func action_tooltip() -> String:
	return "Press E to view the cartridge"

func action_enabled() -> bool:
	return not discard

func action_use(_player: Player):
	if discard:
		return
	discard = true
	
	var cartridge_ui = preload("res://gui/cartridge_ui.tscn").instantiate()
	cartridge_ui.on_close.connect(func(): self.discard = false)
	cartridge_ui.set_key(key_to_display)
	Main.the.add_ui(cartridge_ui)
	
