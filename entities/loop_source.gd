extends StaticBody2D

var destroyed: bool = false
var health: int = 100

signal source_destroyed

func damage(v: int):
	if destroyed:
		return

	health -= v
	if health <= 0:
		$Sprite2D.region_rect.position.x = 48.0
		destroyed = true

		Main.the.end_game()
		source_destroyed.emit()
