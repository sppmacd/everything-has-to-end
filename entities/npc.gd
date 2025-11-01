extends CharacterBody2D

const WALKING_SPEED: float = 4000

# flipped = facing left
var dead = false
var flipped = true
var walking = false
var following_player = false
var shooting = false

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
	dead = true
	velocity.x = 0
	await get_tree().create_timer(0.7).timeout
	var player: Player = Main.the.current_level().player()
	player.add_key(Keys.lvl2_floor0_upstairs)
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

	var p = raytrace_player()
	if p:
		var shell = preload("res://entities/shell.tscn").instantiate()
		Main.the.current_level().add_child(shell)
		shell.setup(self, $GunMarker.global_position, p - Vector2(0, 50))


func ai():
	var p = raytrace_player()
	if following_player:
		if p:
			$PlayerFollowingCooldown.start()
			var should_walk = abs(p.x - global_position.x) > 200
			walking = should_walk
			if not should_walk and $GunTimer.is_stopped():
				print("START GUN TIMER")
				$GunTimer.start()
				print("shooting=true")
				shooting = true
			set_flipped(p.x < global_position.x)
		else:
			walking = false
	else:
		$GunTimer.stop()
		if p:
			walking = true
			following_player = true
			$PlayerFollowingCooldown.start()
		else:
			walking = false

func _physics_process(delta: float) -> void:
	if dead:
		return

	ai()
	
	if walking:
		velocity.x += -WALKING_SPEED * delta if flipped else WALKING_SPEED * delta
	velocity.x *= 0.00001 ** delta
	move_and_slide()


func _animation_process() -> void:
	if dead:
		return
	if walking:
		$AnimatedSprite2D.play("run")
	else:
		if not shooting:
			$AnimatedSprite2D.play("idle")


func _process(_delta: float) -> void:
	_animation_process()


func _on_lookaround_timer_timeout() -> void:
	if following_player:
		var p = raytrace_player()
		if not p:
			set_flipped(not flipped)
	else:
		set_flipped(not flipped)


func _on_player_following_cooldown_timeout() -> void:
	following_player = false


func _on_gun_timer_timeout() -> void:
	start_shooting()
