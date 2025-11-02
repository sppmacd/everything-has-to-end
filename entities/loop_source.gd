extends StaticBody2D

var destroyed: bool = false
var health: int = 25

signal source_destroyed

func scale_f(x):
	var y = 1-x*(x-1)*0.5
	print(x,y)
	scale = Vector2(y, y)


func damage(v: int):
	if destroyed:
		return

	health -= v
	$GPUParticles2D.emitting = true
	get_tree().create_timer(0.05).timeout.connect(func():
		$GPUParticles2D.emitting = false
	)
	var tween_scale = create_tween()
	
	tween_scale.tween_method(scale_f, 0.0, 1.0, 0.2)
	
	if health <= 0:
		$Sprite2D.region_rect.position.x = 48.0
		destroyed = true

		Main.the.end_game()
		source_destroyed.emit()
