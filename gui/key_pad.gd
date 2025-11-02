extends CenterContainer

signal key_entered(key: String)

func _ready() -> void:
	%TextEdit.grab_focus()

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_ESCAPE:
			close()

func set_hint(hint: String):
	%Hint.text = "Hint: %s" % [hint]

func close():
	queue_free()

func on_incorrect_key():
	%IncorrectKey.text = "Incorrect key!"
	%TextEdit.editable = false
	await get_tree().create_timer(2).timeout
	%TextEdit.editable = true
	%IncorrectKey.text = ""


func _on_text_edit_text_submitted(new_text: String) -> void:
	key_entered.emit(new_text)
