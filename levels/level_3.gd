extends GameLevel

func _ready():
	super._ready()
	$LoopSource.source_destroyed.connect(func():
		Main.the.current_level().player().damage(100000000)
		self.respawn_timer.stop()
		Main.the.current_level().time_remaining_changed.emit()
	)
