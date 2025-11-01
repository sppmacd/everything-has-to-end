class_name SpeechBubble
extends Node2D
@onready var SpeechText = $SpeechText

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func show_message(text: String, duration := 2.0):
	SpeechText.text = text
	show()
	await get_tree().create_timer(duration).timeout
	hide()
