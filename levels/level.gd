extends Node2D

@onready var player: Player = $Player
@onready var spawn_point: Marker2D = $SpawnPoint

func _ready() -> void:
    respawn_player()
    
func respawn_player():
    player.position = spawn_point.global_position

func _unhandled_key_input(event: InputEvent) -> void:
    if event is InputEventKey:
        if event.keycode == KEY_R and event.is_pressed():
            respawn_player()

func _on_respawn_timer_timeout() -> void:
    respawn_player()
