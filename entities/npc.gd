extends CharacterBody2D

const WALKING_SPEED: float = 4000

# flipped = facing left
var dead = false
var flipped = true
var walking = false
var following_player = false

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
	velocity = Vector2()
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


func ai():
	var p = raytrace_player()
	if following_player:
		if p:
			$PlayerFollowingCooldown.start()
			walking = abs(p.x - global_position.x) > 100
			set_flipped(p.x < global_position.x)
		else:
			walking = false
	else:
		if p:
			walking = true
			following_player = true
			$PlayerFollowingCooldown.start()
		else:
			walking = false

func _physics_process(delta: float) -> void:
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
		$AnimatedSprite2D.play("idle")


func _process(_delta: float) -> void:
	_animation_process()
	

func _on_timer_timeout() -> void:
	var p = raytrace_player()
	if p:
		var shell = preload("res://entities/shell.tscn").instantiate()
		Main.the.current_level().add_child(shell)
		shell.setup(self, $GunMarker.global_position, p)


func _on_lookaround_timer_timeout() -> void:
	if following_player:
		var p = raytrace_player()
		if not p:
			set_flipped(not flipped)
	else:
		set_flipped(not flipped)


func _on_player_following_cooldown_timeout() -> void:
	following_player = false
