extends CenterContainer
var key_str: String
@onready var key_label = $PanelContainer/VBoxContainer/KeyLabel

func _ready() -> void:
	key_label.text = key_str
	
func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_ESCAPE:
			close()

func set_key(key: String):
	key_str = key

func close():
	queue_free()
