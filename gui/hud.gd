extends Control

func setup(player: Player):
	player.key_added.connect(func():
		update_keys_ui(player)
	)


func update_keys_ui(player: Player):
	for q in $Keys.get_children():
		q.queue_free()
	
	for key in player.keys:
		var q = TextureRect.new()
		q.texture = load(Keys.KEY_TEXTURES[key])
		q.custom_minimum_size = Vector2(64, 64)
		$Keys.add_child(q)
