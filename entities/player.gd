class_name Player
extends CharacterBody2D

const WALKING_SPEED: float = 5000

@onready var use_area: Area2D = $UseArea
@onready var label_press_e_to_use = $PressEToUse
@onready var gun_point = $GunPoint
var can_use_objects: bool = true
var moving: bool = false
var flipped: bool = false

func _animation_process(delta: float) -> void:
	if moving:
		$Sprite2D.play("run")
	else:
		$Sprite2D.play("idle")
	if abs(velocity.x) > 0.01:
		flipped = velocity.x < 0
	$Sprite2D.flip_h = flipped
	$Sprite2D.offset.x = -12 if flipped else 12

func _physics_process(delta: float) -> void:
	moving = false
	if Input.is_key_pressed(KEY_A):
		velocity.x -= WALKING_SPEED * delta
		moving = true
	if Input.is_key_pressed(KEY_D):
		velocity.x += WALKING_SPEED * delta
		moving = true
	velocity.x *= 0.00001 ** delta
	velocity.y += 981 * delta
	move_and_slide()


func _find_usable_objects() -> Array[Node2D]:
	var area = use_area.get_overlapping_bodies()
	return area


func _process(delta: float) -> void:
	label_press_e_to_use.visible = len(_find_usable_objects()) > 0
	_animation_process(delta)


func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_E and event.is_pressed() and can_use_objects:
			var uo = _find_usable_objects()
			if len(uo) > 0:
				uo[0].action_use(self)
				can_use_objects = false
				
				var timer = get_tree().create_timer(0.1)
				timer.timeout.connect(func(): self.can_use_objects = true)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var shell = preload("res://entities/shell.tscn").instantiate()
			var mouse_pos = get_global_mouse_position()
			Main.the.current_level().add_child(shell)
			shell.setup(self, gun_point.global_position, mouse_pos)
