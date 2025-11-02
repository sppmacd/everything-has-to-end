extends Control

func _ready():
	_show()


func show_text(text: String, time: float):
	%RichTextLabel.text = text
	%RichTextLabel.modulate = Color8(255,255,255,0)

	var tween = create_tween()
	tween.tween_property(%RichTextLabel, "modulate", Color8(255,255,255,255), 1.0)
	tween.tween_interval(time)
	tween.tween_property(%RichTextLabel, "modulate", Color8(255,255,255,0), 1.0)

	await get_tree().create_timer(time + 2).timeout


func _show():
	# EXPLOSION
	var tween = create_tween()
	tween.tween_property($Background, "color", Color8(255,255,255,255), 0.1)
	tween.tween_interval(5.0)
	tween.tween_property($Background, "color", Color8(0,0,0,255), 1.0)
	await get_tree().create_timer(5).timeout
	Main.the.get_node("AudioStreamPlayer").playing = false # Hack to fix broken music.
	await get_tree().create_timer(2).timeout

	# play music
	$AudioStreamPlayer.play()

	# ACTUAL CREDITS
	var TEXT_TIME = 5.5
	await show_text("You managed to escape from the time loop.", TEXT_TIME)
	await show_text("Damage to the source caused a short circuit that set everything on fire.", TEXT_TIME)
	await show_text("The Ministry of Order was destroyed by explosion of the Source.", TEXT_TIME)
	await show_text("Nobody would be able to survive this.", TEXT_TIME)

	var tween2 = create_tween()
	tween2.tween_property(%Credits, "modulate", Color8(255,255,255,255), 1.0)
