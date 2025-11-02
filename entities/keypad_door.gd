extends StaticBody2D

@export
var correct_key: String
@export
var hint: String

var open = false

func _on_set_open(open: bool):
	collision_layer = 0x2 if open else 0x3
	$LightOccluder2D.visible = not open
	$LightOccluder2D2.visible = not open

func _ready():
	_on_set_open(false)

func action_use(player: Player):
	if open:
		open = false
		_on_set_open(false)
		return
	
	var keypad_ui = preload("res://gui/key_pad.tscn").instantiate()
	keypad_ui.key_entered.connect(func(key):
		if key == correct_key:
			keypad_ui.close()
			open = true
			_on_set_open(true)
		else:
			keypad_ui.on_incorrect_key()
	)
	keypad_ui.set_hint(hint)
	Main.the.add_ui(keypad_ui)

func action_tooltip() -> String:
	return "Press E to enter the key"

func action_enabled() -> bool:
	return true
