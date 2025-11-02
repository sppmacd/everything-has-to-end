extends StaticBody2D

var destroyed: bool = false

func damage(_v: int):
	$Sprite2D.texture = preload("res://assets/objects/camera_destroyed.tres")
	$Polygon2D.visible = false
	destroyed = true


func _on_area_2d_body_entered(body: Node2D) -> void:
	if destroyed:
		return
	var cr = Main.the.current_level()
	if body == cr.player() and cr.has_method(&"launch_alarm"):
		cr.launch_alarm()
