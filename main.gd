class_name Main
extends Node2D

static var the: Main
var _current_level: Node2D
var _checkpoint_level: Node2D
signal checkpoint_set

func _ready():
	the = self
	switch_level(preload("res://levels/level3.tscn").instantiate())
	set_new_checkpoint()
	_checkpoint_level.respawn_player()

func on_player_changed():
	$CanvasLayer/Hud.setup(current_level().player(), _current_level)

# called only when player was killed NOT by the time loop
func on_player_death():
	$AudioStreamPlayer.play(193.0)

func on_respawn():
	$AudioStreamPlayer.play()

func current_level():
	return _current_level

func checkpoint_level():
	return _checkpoint_level
	
func set_new_checkpoint():
	_checkpoint_level = _current_level
	checkpoint_set.emit()

func switch_level(lvl: Node2D):
	if has_node("Level"):
		var player: Node2D = get_node("Level").player()
		player.reparent(lvl)
		remove_child(get_node("Level"))
	_current_level = lvl
	lvl.name = "Level"
	add_child(lvl)
	if current_level().player():
		$CanvasLayer/Hud.setup(current_level().player(), lvl)
		current_level().player().global_position = current_level().spawn_point().global_position

func add_ui(node: Node):
	$CanvasLayer.add_child(node)
