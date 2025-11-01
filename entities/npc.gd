extends CharacterBody2D

const WALKING_SPEED: float = 2000

# flipped = facing left
var dead = false
var flipped = true
var walking_speed = 0.0

enum State {
	LOOKING_AROUND,
	FOLLOWING_PLAYER,
	RETREATING
}
var spawn_door: Door
var state: State = State.LOOKING_AROUND
var shooting: bool = false
var keys_inventory: Array[String] = []

func set_flipped(f: bool):
	flipped = f
	$AnimatedSprite2D.flip_h = flipped
	$AnimatedSprite2D.offset.x = -12 if flipped else 12
	$RayCast2D.target_position = sight_vector() * 10000


func _ready() -> void:
	$AnimatedSprite2D.play("idle")
	$PlayerFollowingCooldown.start()


func sight_vector() -> Vector2:
	return Vector2.LEFT if flipped else Vector2.RIGHT


func damage(v: int):
	print("DAMAGE ", v)
	$AnimatedSprite2D.play("death")
	dead = true
	velocity.x = 0
	await get_tree().create_timer(0.7).timeout
	var player: Player = Main.the.current_level().player()
	for key in keys_inventory:
		player.add_key(key)
	queue_free()


func raytrace_player():
	var player: Player = Main.the.current_level().player()
	var collider = $RayCast2D.get_collider()
	if collider and collider == player:
		return collider["position"]
	return null


func start_shooting():
	if dead:
		return

	$AnimatedSprite2D.play("attack")
	print("shooting=true")
	shooting = true
	await get_tree().create_timer(0.6).timeout
	print("shooting=false")
	shooting = false

	if dead:
		return
	var p = raytrace_player()
	if p:
		var shell = preload("res://entities/shell.tscn").instantiate()
		Main.the.current_level().add_child(shell)
		shell.setup(self, $GunMarker.global_position, p - Vector2(0, 50))


func ai():
	var p = raytrace_player()
	match state:
		State.LOOKING_AROUND:
			if p:
				state = State.FOLLOWING_PLAYER
				print("cooldown restart")
				$PlayerFollowingCooldown.start()
			if randf() < 0.02 and walking_speed == 0.0:
				(func():
					print("random walk")
					walking_speed = 1.0
					await get_tree().create_timer(0.3).timeout
					walking_speed = 0.0
				).call_deferred()
		State.FOLLOWING_PLAYER:
			if p:
				print("cooldown restart")
				$PlayerFollowingCooldown.start()
				var should_walk = abs(p.x - global_position.x) > 200
				walking_speed = 2.0 if should_walk else 0.0
				#$Debug.text = "state=%d player=%s should_walk=%s" % [state, p, should_walk]
				if not should_walk and $GunTimer.is_stopped():
					print("START GUN TIMER")
					start_shooting.call_deferred()
					$GunTimer.start()
					print("shooting=true")
					shooting = true
				set_flipped(p.x < global_position.x)
			else:
				$GunTimer.stop()
		State.RETREATING:
			if p:
				state = State.FOLLOWING_PLAYER
				print("cooldown restart")
				$PlayerFollowingCooldown.start()
			walking_speed = 1.0
			set_flipped(spawn_door.global_position.x < global_position.x)
			if abs(spawn_door.global_position.x - global_position.x) < 20:
				queue_free()

func _physics_process(delta: float) -> void:
	if dead:
		return

	ai()

	if walking_speed > 0.0:
		velocity.x += walking_speed * (-WALKING_SPEED * delta if flipped else WALKING_SPEED * delta)
	velocity.x *= 0.00001 ** delta
	move_and_slide()


func _animation_process() -> void:
	if dead:
		return
	if walking_speed > 0.0:
		$AnimatedSprite2D.play("run")
	else:
		if not shooting:
			$AnimatedSprite2D.play("idle")


func _process(_delta: float) -> void:
	_animation_process()


func _on_lookaround_timer_timeout() -> void:
	match state:
		State.FOLLOWING_PLAYER:
			var p = raytrace_player()
			if not p:
				set_flipped(not flipped)
		State.LOOKING_AROUND:
			set_flipped(not flipped)
		State.RETREATING:
			pass


func _on_player_following_cooldown_timeout() -> void:
	print("RETREATING!")
	state = State.RETREATING


func _on_gun_timer_timeout() -> void:
	start_shooting()
