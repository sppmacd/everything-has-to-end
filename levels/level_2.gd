extends GameLevel

var alarm: bool = false: set = set_alarm

signal alarm_state_changed(state: bool)

func set_alarm(a: bool):
	alarm = a
	alarm_state_changed.emit(a)
	if $AlarmSound.playing != a:
		$AlarmSound.playing = a
	
func launch_alarm():
	print("!@!@!@! LAUNCH ALARM !@!@!@!")
	alarm = true
	await get_tree().create_timer(20).timeout
	alarm = false
