extends StaticBody2D

func damage(v: int):
	$Sprite2D.texture = preload("res://assets/objects/camera_destroyed.tres")


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("body ", body, " entered camera area")
