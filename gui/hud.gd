extends Control


func setup(player: Player, level: GameLevel):
	player.key_added.connect(func():
		update_keys_ui(player)
	)
	player.ammo_changed.connect(func():
		update_ammo_ui(player)
	)
	player.health_changed.connect(func():
		update_health_ui(player)
	)
	level.time_remaining_changed.connect(func():
		update_time_remaining_ui(level)
	)
	update_keys_ui(player)
	update_ammo_ui(player)
	update_health_ui(player)
	update_time_remaining_ui(level)


func update_keys_ui(player: Player):
	for q in %Keys.get_children():
		q.queue_free()

	for key in player.keys:
		var q = TextureRect.new()
		q.texture = load(Keys.KEY_TEXTURES[key])
		q.custom_minimum_size = Vector2(32, 32)
		%Keys.add_child(q)

func update_ammo_ui(player: Player):
	%Ammo.text = "Ammo: " + str(player.ammo)

func update_health_ui(player: Player):
	%Health.text = "Health: " + str(player.health)


func _set_time_remaining(time_remaining: float, cycle_length: float):
	%TimeRemaining.text = "TIME REMAINING: " + str(ceil(time_remaining)) + "s"
	$Vignette.modulate = Color8(255, 255, 255, 255 - 255 * time_remaining / cycle_length)
	var corruption_amount = max(0, (30 - time_remaining)) / 30
	$CorruptionShader.material.set_shader_parameter("amount", corruption_amount / 100)
	$CorruptionShader.material.set_shader_parameter("grayscale_fac", corruption_amount)

func update_time_remaining_ui(level: GameLevel):
	_set_time_remaining(level.time_remaining(), level.cycle_length())
	
