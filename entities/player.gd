class_name Player
extends CharacterBody2D

const WALKING_SPEED: float = 5000
const JUMP_SPEED: float = -400.0
const GRAVITY: float = 981.0
const PUNCHING_DELAY_SEC: float = 0.4
const LOADING_GUN_DELAY_SEC: float = 0.2
const GUN_IDLE_DELAY_SEC: float = 0.5

@onready var use_area: Area2D = $UseArea
@onready var label_press_e_to_use = $PressEToUse
@onready var gun_point = $GunPoint
@onready var speech_bubble = $SpeechBubble
var can_use_objects: bool = true
var moving: bool = false
var jumping: bool = false
var punching: bool = false
var flipped: bool = false
var gun_loaded: bool = false
var gun_loading: bool = false
var gun_unloading: bool = false
var last_shot_timestamp: int = 0

var keys: Array[String] = []

func has_key(key: String):
	return key in keys

func add_key(key: String):
	keys.append(key)

func _animation_process(delta: float) -> void:
	if jumping:
		$Sprite2D.play("jump")
	elif punching:
		$Sprite2D.play("punch")
	elif moving:
		if gun_loading:
			$Sprite2D.play("show_gun_running")
		elif gun_loaded:
			$Sprite2D.play("gun_running")
		elif gun_unloading:
			$Sprite2D.play("hide_gun_running")
		else:
			$Sprite2D.play("running")
	else:
		if gun_loading:
			$Sprite2D.play("show_gun_idle")
		elif gun_loaded:
			$Sprite2D.play("gun_idle")
		elif gun_unloading:
			$Sprite2D.play("hide_gun_idle")
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
	
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		jumping = false

	if Input.is_key_pressed(KEY_SPACE) and is_on_floor():
		velocity.y = JUMP_SPEED
		jumping = true

	velocity.x *= 0.00001 ** delta
	velocity.y += 981 * delta
	
	if gun_loaded and Time.get_ticks_msec() - last_shot_timestamp > GUN_IDLE_DELAY_SEC * 1000.0:
		gun_loaded = false
		gun_unloading = true
		
		var timer = get_tree().create_timer(LOADING_GUN_DELAY_SEC)
		timer.timeout.connect(func(): self.gun_unloading = false)
		
	
	move_and_slide()


func _find_usable_objects() -> Array[Node2D]:
	var area = use_area.get_overlapping_bodies()
	return area

func _label_process(delta: float) -> void:
	label_press_e_to_use.visible = len(_find_usable_objects()) > 0

func _process(delta: float) -> void:
	var uo = _find_usable_objects()
	if len(uo) > 0:
		if uo[0].action_enabled():
			label_press_e_to_use.text = uo[0].action_tooltip()
			label_press_e_to_use.visible = true
		else:
			label_press_e_to_use.visible = false
	else:
		label_press_e_to_use.visible = false
	
	_animation_process(delta)


func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_E and event.is_pressed() and can_use_objects:
			var uo = _find_usable_objects()
			if len(uo) > 0:
				if uo[0].action_enabled():
					uo[0].action_use(self)
					can_use_objects = false
					
					var timer = get_tree().create_timer(0.1)
					timer.timeout.connect(func(): self.can_use_objects = true)

func _spawn_shell() -> void:
	var shell = preload("res://entities/shell.tscn").instantiate()
	var mouse_pos = get_global_mouse_position()
	Main.the.current_level().add_child(shell)
	shell.setup(self, gun_point.global_position, mouse_pos)
	
	gun_loading = false
	gun_unloading = false
	gun_loaded = true
	last_shot_timestamp = Time.get_ticks_msec()
			
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if jumping:
				return
			
			var mouse_pos = get_global_mouse_position()
			if moving and flipped != (gun_point.global_position.x > mouse_pos.x):
				return
			flipped = (gun_point.global_position.x > mouse_pos.x)
			
			if not gun_loaded:
				gun_loading = true
				var timer = get_tree().create_timer(LOADING_GUN_DELAY_SEC)
				timer.timeout.connect(func(): _spawn_shell())
			else:
				_spawn_shell()
				
func Punch() -> void:
	punching = true
	var timer = get_tree().create_timer(PUNCHING_DELAY_SEC)
	timer.timeout.connect(func(): self.punching = false)

func Speak(text: String) -> void:
	speech_bubble.show_message(text)
