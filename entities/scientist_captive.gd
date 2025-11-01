class_name ScientistCaptive
extends CharacterBody2D
@onready var SpeechText = $SpeechBubble

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()

func _ready():
	$AnimatedSprite2D.play("idle")

func action_tooltip() -> String:
	return "Press E to talk"

func action_use(player: Player):
	SpeechText.show_message("Fuck you! I won't tell you anything!")
