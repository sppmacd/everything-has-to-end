extends Door

const tex_open = preload("res://assets/objects/door_open.tres")
const tex_closed = preload("res://assets/objects/door_closed.tres")

@onready var sprite: Sprite2D = $Sprite2D

@export
var key_chances: Dictionary[String, float]

var _alarm_state: bool = false

func _ready():
	open = true
	var cr = Main.the.current_level()
	if cr.has_signal(&"alarm_state_changed"):
		cr.alarm_state_changed.connect(self._on_alarm_state_changed)

func _on_alarm_state_changed(state: bool):
	_alarm_state = state

func _on_set_open(open: bool):
	print("on set open")
	sprite.texture = tex_open if open else tex_closed

func _on_spawn_timer_timeout() -> void:
	print("spawn timer timeout open=", self.open)
	var p = 0.9 if _alarm_state else 0.1
	var limit = 10 if _alarm_state else 4
	if randf() < p and self.open:
		if len(get_tree().get_nodes_in_group("npc")) >= limit:
			return
		const npc_scene = preload("res://entities/npc.tscn")
		var npc = npc_scene.instantiate()
		Main.the.current_level().add_child(npc)
		npc.spawn_door = self
		npc.position = global_position
		for k in key_chances:
			if randf() < key_chances[k]:
				npc.keys_inventory.append(k)
