extends StaticBody2D

var destroyed: bool = false

signal source_destroyed

func damage(_v: int):
	if destroyed:
		return
	$Sprite2D.region_rect.position.x = 48.0
	destroyed = true
	
	Main.the.end_game()
	source_destroyed.emit()
