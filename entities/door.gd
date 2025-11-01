extends Door

const tex_open = preload("res://assets/objects/door_open.tres")
const tex_closed = preload("res://assets/objects/door_closed.tres")

@onready var sprite: Sprite2D = $Sprite2D

func _ready():
	open = true

func _on_set_open(open: bool):
	print("on set open")
	sprite.texture = tex_open if open else tex_closed

func _on_spawn_timer_timeout() -> void:
	print("spawn timer timeout open=", self.open)
	if randf() < 0.9 and self.open:
		if len(get_tree().get_nodes_in_group("npc")) > 0:
			return
		const npc_scene = preload("res://entities/npc.tscn")
		var npc = npc_scene.instantiate()
		Main.the.current_level().add_child(npc)
		npc.position = global_position
