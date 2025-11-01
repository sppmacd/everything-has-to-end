extends CharacterBody2D


# flipped = facing left
var flipped = true


func set_flipped(f: bool):
	flipped = f
	$AnimatedSprite2D.flip_h = flipped
	$AnimatedSprite2D.offset.x = -12 if flipped else 12
	$RayCast2D.target_position = sight_vector() * 10000


func _ready() -> void:
	$AnimatedSprite2D.play("idle")


func sight_vector() -> Vector2:
	return Vector2.LEFT if flipped else Vector2.RIGHT


func damage(v: int):
	print("DAMAGE ", v)
	$AnimatedSprite2D.play("death")
	await get_tree().create_timer(0.7).timeout
	var player: Player = Main.the.current_level().player()
	player.add_key(Keys.lvl2_floor0_upstairs)
	queue_free()


func raytrace_player():
	var player: Player = Main.the.current_level().player()
	var collider = $RayCast2D.get_collider()
	if collider and collider == player:
		return player.global_position
	return null


func _physics_process(delta: float) -> void:
	var p = raytrace_player()
	print(p)


func _on_timer_timeout() -> void:
	set_flipped(not flipped)
	var shell = preload("res://entities/shell.tscn").instantiate()
	var player = Main.the.current_level().get_node("Player")
	Main.the.current_level().add_child(shell)
	shell.setup(self, $GunMarker.global_position, player.global_position - Vector2(0, 50))
