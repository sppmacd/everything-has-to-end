class_name Player
extends CharacterBody2D

const WALKING_SPEED: float = 200

@onready var use_area: Area2D = $UseArea
@onready var label_press_e_to_use = $PressEToUse
var can_use_objects: bool = true

func _physics_process(delta: float) -> void:
    if Input.is_key_pressed(KEY_A):
        position.x -= WALKING_SPEED * delta
    if Input.is_key_pressed(KEY_D):
        position.x += WALKING_SPEED * delta
    velocity.y += 981 * delta
    move_and_slide()


func _find_usable_objects() -> Array[Node2D]:
    var area = use_area.get_overlapping_bodies()
    return area


func _process(delta: float) -> void:
    label_press_e_to_use.visible = len(_find_usable_objects()) > 0


func _unhandled_key_input(event: InputEvent) -> void:
    if event is InputEventKey:
        if event.keycode == KEY_E and event.is_pressed() and can_use_objects:
            var uo = _find_usable_objects()
            if len(uo) > 0:
                uo[0]._action_use(self)
                can_use_objects = false
                
                var timer = get_tree().create_timer(0.1)
                timer.timeout.connect(func(): self.can_use_objects = true)
