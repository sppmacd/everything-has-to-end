class_name GameLevel
extends Node2D

signal time_remaining_changed

func player() -> Player:
	return get_node_or_null("Player")

func spawn_point() -> Marker2D:
	return get_node_or_null("SpawnPoint")

func respawn_player():
	if player():
		# Old player, if exists, remains as a body until picked up
		player().get_node("Camera2D").queue_free()
		player().name = "PlayerBody"

	# Spawn new player, and move it to spawn position.
	var new_player = preload("res://entities/player.tscn").instantiate()
	new_player.name = "Player"
	new_player.global_position = spawn_point().global_position
	add_child(new_player)

	Main.the.on_player_changed()
	Main.the.on_respawn()
	$RespawnTimer.start()

#func _unhandled_key_input(event: InputEvent) -> void:
	#if event is InputEventKey:
		#if event.keycode == KEY_R and event.is_pressed():
			#respawn_player()

func _on_respawn_timer_timeout() -> void:
	var p = player()
	if p:
		p.damage(10000000)


func time_remaining():
	return $RespawnTimer.time_left


func cycle_length():
	return $RespawnTimer.wait_time


func _on_update_timer_timeout() -> void:
	time_remaining_changed.emit()
