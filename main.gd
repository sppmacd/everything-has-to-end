class_name Main
extends Node2D

static var the: Main
var _current_level: Node2D

func _ready():
	the = self
	switch_level(preload("res://levels/level2.tscn").instantiate())
	_current_level.add_child(preload("res://entities/player.tscn").instantiate())
	_current_level.respawn_player()
	$CanvasLayer/Hud.setup(current_level().player())

func current_level():
	return _current_level

func switch_level(lvl: Node2D):
	if has_node("Level"):
		var player: Node2D = get_node("Level").player()
		player.reparent(lvl)
		remove_child(get_node("Level"))
	_current_level = lvl
	lvl.name = "Level"
	add_child(lvl)
