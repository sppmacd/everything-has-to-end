extends Control

func setup(player: Player):
	player.key_added.connect(func():
		update_keys_ui(player)
	)
	player.ammo_changed.connect(func():
		update_ammo_ui(player)
	)
	player.health_changed.connect(func():
		update_health_ui(player)
	)
	update_keys_ui(player)
	update_ammo_ui(player)
	update_health_ui(player)


func update_keys_ui(player: Player):
	for q in $Keys.get_children():
		q.queue_free()
	
	for key in player.keys:
		var q = TextureRect.new()
		q.texture = load(Keys.KEY_TEXTURES[key])
		q.custom_minimum_size = Vector2(32, 32)
		$Keys.add_child(q)

func update_ammo_ui(player: Player):
	$Ammo.text = "Ammo: " + str(player.ammo)
	
func update_health_ui(player: Player):
	$Health.text = "Health: " + str(player.health)
	
