extends CharacterBody2D

func damage(v: int):
    print("DAMAGE ", v)
    queue_free()


func _on_timer_timeout() -> void:
    var shell = preload("res://entities/shell.tscn").instantiate()
    var player = Main.the.current_level().get_node("Player")
    Main.the.current_level().add_child(shell)
    shell.setup(self, $GunMarker.global_position, player.global_position - Vector2(0, 50))
