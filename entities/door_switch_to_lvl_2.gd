extends StaticBody2D

signal use(player: Player)

@export
var required_key: String
@export
var level: PackedScene
@export
var description: String

func set_required_key(rk: String):
	required_key = rk

func action_use(player: Player):
	if required_key and not player.has_key(required_key):
		print("requires key ", required_key)
		return
	
	Main.the.switch_level(level.instantiate())
	
	use.emit(player)

func action_tooltip() -> String:
	return description

func action_enabled() -> bool:
	return true
