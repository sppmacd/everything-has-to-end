class_name Biker
extends CharacterBody2D
var discard: bool = false
var lines: Array[String] = [
	"Hey bro, I've got few tips for ya before you head out!",
	"Walk with A and D",
	"Do actions with E, pointing at the object may help",
	"Accept with ENTER, close with Esc",
	"Shoot with left button",
	"These autocrats have ammo and other items hidden in their storage",
	"Close enemy doors with a red button.",
	"Open corridor doors with keys enemy robots drop.",
	"If you destroy enemy's cameras, they ain't gonna see ya",
	"Good luck, brother! We'all countin' on ya!",
	]
const SPEECH_LINE_DELAY: float = 5
@onready var SpeechText = $SpeechBubble

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()

func _ready():
	$AnimatedSprite2D.play("idle")
	$AnimatedSprite2D.flip_h = true
	$AnimatedSprite2D.offset.x = -12
	
func action_tooltip() -> String:
	return "Press E to talk"

func action_enabled() -> bool:
	return not discard

func action_use(player: Player):
	if discard:
		return
	discard = true

	player.speak("Hey bro! Wassup?")

	var delay := 2.5
	for text in lines:
		var timer := get_tree().create_timer(delay)
		delay += SPEECH_LINE_DELAY
		timer.timeout.connect(func():
			SpeechText.show_message(text, SPEECH_LINE_DELAY - 0.2)
		)

	var final_timer := get_tree().create_timer(delay + SPEECH_LINE_DELAY)
	final_timer.timeout.connect(func():
		discard = false
	)
