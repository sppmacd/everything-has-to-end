extends Node2D

func _physics_process(delta: float) -> void:
    if Input.is_key_pressed(KEY_A):
        position.x -= 10
    if Input.is_key_pressed(KEY_D):
        position.x += 10
