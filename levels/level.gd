class_name GameLevel
extends Node2D

@onready var spawn_point: Marker2D = $SpawnPoint

func player() -> Player:
	return get_node_or_null("Player")

func respawn_player():
	if player():
		# Old player, if exists, remains as a body until picked up
		player().get_node("Camera2D").queue_free()
		player().name = "PlayerBody"

	# Spawn new player, and move it to spawn position.
	var player = preload("res://entities/player.tscn").instantiate()
	player.name = "Player"
	player.global_position = spawn_point.global_position
	add_child(player)
	
	Main.the.on_player_changed()

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_R and event.is_pressed():
			respawn_player()

func _on_respawn_timer_timeout() -> void:
	var p = player()
	if p:
		p.damage(10000000)
