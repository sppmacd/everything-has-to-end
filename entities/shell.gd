extends Node2D

@onready var line: Line2D = $Line2D
@onready var timer: Timer = $Timer

func _ready() -> void:
	var t = create_tween()
	line.default_color = Color8(255, 0, 0, 100)
	t.tween_property(line, "default_color", Color8(255, 0, 0, 0), timer.time_left)


func _raytrace_end(shooter: PhysicsBody2D, start: Vector2, end: Vector2):
	var q = PhysicsRayQueryParameters2D.new()
	q.from = start
	q.to = end + (end - start).normalized()*10000
	q.collision_mask = 0x5 # "Collision", Damage"
	q.exclude = [shooter.get_rid()]
	var result = get_world_2d().direct_space_state.intersect_ray(q)
	return result


func setup(shooter: PhysicsBody2D, start: Vector2, end: Vector2):
	print(end)
	var raytrace_result = _raytrace_end(shooter, start, end)
	if "position" in raytrace_result:
		end = raytrace_result["position"]
		var collider = raytrace_result["collider"]
		if collider.has_method("damage"):
			collider.damage(1)
	else:
		end += (end - start).normalized() * 10000
	line.add_point(start)
	line.add_point(end)


func _on_timer_timeout() -> void:
	queue_free()
