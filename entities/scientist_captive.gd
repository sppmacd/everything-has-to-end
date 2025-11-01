class_name ScientistCaptive
extends CharacterBody2D
@onready var SpeechText = $SpeechBubble
var mode: int = 0
var discard: bool = false

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()

func _ready():
	$AnimatedSprite2D.play("idle")

func action_tooltip() -> String:
	if mode == 1:
		return "Press E to punch"
	return "Press E to talk"

func action_enabled() -> bool:
	return not discard

func _action_mode_0():
	SpeechText.show_message("Fuck you! I won't tell you anything!")
	mode = 1
	
	var timer = get_tree().create_timer(2.0)
	timer.timeout.connect(func(): self.discard = false)

func _action_mode_1():
	SpeechText.show_message("Okay, okay! My job isn't worth it.")
	mode = 2
	
	var timer = get_tree().create_timer(2.0)
	timer.timeout.connect(func(): self.discard = false)

func _action_mode_2_1():
	SpeechText.show_message("You die every few minutes because we inserted chips inside your brains.")
	
	var timer = get_tree().create_timer(2.0)
	timer.timeout.connect(func(): self.discard = false)

func _action_mode_2_2():
	SpeechText.show_message("Because of the time loop, you'll go back in time and remember every time you die.")
	mode = 3
	
	var timer = get_tree().create_timer(2.0)
	timer.timeout.connect(func(): self.discard = false)

func _action_mode_3_1():
	SpeechText.show_message("It cannot be deactivated, but a new timestamp can be set.")
	
	var timer = get_tree().create_timer(2.0)
	timer.timeout.connect(func(): self.discard = false)

func _action_mode_3_2():
	SpeechText.show_message("But that won't stop the time loop, you need to destroy its source.")
	mode = 4
	
	var timer = get_tree().create_timer(2.0)
	timer.timeout.connect(func(): self.discard = false)

func _action_mode_4():
	SpeechText.show_message("It's in the control room on the top floor of ministry of order.")
	mode = 5
	
	var timer = get_tree().create_timer(2.0)
	timer.timeout.connect(func(): self.discard = false)

func _action_mode_5():
	SpeechText.show_message("No, I swear that's all I know!")
	mode = 2
	
	var timer = get_tree().create_timer(2.0)
	timer.timeout.connect(func(): self.discard = false)

func action_use(player: Player):
	if discard:
		return
	if mode == 0:
		discard = true;
		
		var p = get_node("../Player")
		p.Speak("Say everything ya'know about that damn time loop!")
		var timer = get_tree().create_timer(2.2)
		timer.timeout.connect(func(): _action_mode_0())
	elif mode == 1:
		discard = true;
		
		var p = get_node("../Player")
		p.Punch()
		var timer = get_tree().create_timer(1)
		timer.timeout.connect(func(): _action_mode_1())
	elif mode == 2:
		discard = true;
		
		var p = get_node("../Player")
		p.Speak("Then talk or I'll punch u again.")
		var t1 = get_tree().create_timer(2.2)
		t1.timeout.connect(func(): _action_mode_2_1())
		var t2 = get_tree().create_timer(4.4)
		t1.timeout.connect(func(): _action_mode_2_2())
	elif mode == 3:
		discard = true;
		
		var p = get_node("../Player")
		p.Speak("How can we deactivate that?")
		var t1 = get_tree().create_timer(2.2)
		t1.timeout.connect(func(): _action_mode_3_1())
		var t2 = get_tree().create_timer(4.4)
		t1.timeout.connect(func(): _action_mode_3_2())
	elif mode == 4:
		discard = true;
		
		var p = get_node("../Player")
		p.Speak("Where's that source?")
		var t1 = get_tree().create_timer(2.2)
		t1.timeout.connect(func(): _action_mode_4())
	elif mode == 5:
		discard = true;
		
		var p = get_node("../Player")
		p.Speak("Is that all?")
		var t1 = get_tree().create_timer(2.2)
		t1.timeout.connect(func(): _action_mode_5())
		
