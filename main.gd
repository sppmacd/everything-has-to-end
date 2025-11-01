class_name Main
extends Node2D

static var the: Main

func _ready():
	the = self

func current_level():
	return $Level2
