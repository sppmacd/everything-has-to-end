extends GameLevel

func _ready():
	$LoopSource.source_destroyed.connect(func(): self.respawn_timer.stop())
