class_name ScientistCaptive
extends CharacterBody2D

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()

func _ready():
	$AnimatedSprite2D.play("idle")
