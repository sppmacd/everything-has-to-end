extends Node2D


func _on_stairs_up_use(player: Player) -> void:
	Main.the.switch_level(preload("res://levels/level2.tscn").instantiate())
