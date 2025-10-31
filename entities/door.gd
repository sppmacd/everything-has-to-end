extends Node2D

const tex_open = preload("res://assets/objects/door_open.tres")
const tex_closed = preload("res://assets/objects/door_closed.tres")

@onready var sprite: Sprite2D = $Sprite2D
var open: bool = true

func set_open(open: bool):
    sprite.texture = tex_open if open else tex_closed
    self.open = open

func action_use(player: Player):
    set_open(not open)

func _on_spawn_timer_timeout() -> void:
    if randf() < 0.1 and open:
        const npc_scene = preload("res://entities/npc.tscn")
        var npc = npc_scene.instantiate()
        Main.the.current_level().add_child(npc)
        npc.position = global_position
