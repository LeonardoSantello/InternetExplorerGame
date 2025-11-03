extends Sprite2D
class_name spike
var dir: Vector2

func _ready() -> void:
	Global.spikeDamageAmount = 10
	dir = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):   # garanta que seu Player esteja no grupo "player"
		pass
