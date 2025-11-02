class_name GameLevel
extends Node2D
@onready var respawn_timer = $RespawnTimer

var alarm_enabled: bool = false
var alarm: bool = false: set = set_alarm

signal alarm_state_changed(state: bool)
signal time_remaining_changed


func _ready():
	Main.the.checkpoint_set.connect(func(): self.respawn_timer.start())

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
	add_child(new_player)
	Main.the.switch_level(Main.the.checkpoint_level())

	Main.the.on_player_changed()
	Main.the.on_respawn()
	respawn_timer.start()

#func _unhandled_key_input(event: InputEvent) -> void:
	#if event is InputEventKey:
		#if event.keycode == KEY_R and event.is_pressed():
			#respawn_player()

func _on_respawn_timer_timeout() -> void:
	var p = player()
	if p:
		p.damage(10000000)


func time_remaining():
	return respawn_timer.time_left


func cycle_length():
	return respawn_timer.wait_time


func _on_update_timer_timeout() -> void:
	time_remaining_changed.emit()

func set_alarm(a: bool):
	if not alarm_enabled:
		return
	alarm = a
	alarm_state_changed.emit(a)
	if $AlarmSound.playing != a:
		$AlarmSound.playing = a

func launch_alarm():
	if not alarm_enabled:
		return
	print("!@!@!@! LAUNCH ALARM !@!@!@!")
	alarm = true
	await get_tree().create_timer(20).timeout
	alarm = false
