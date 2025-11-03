extends Area2D

@export var heal_bonus := 50   # quanto aumenta a velocidade
@export var duration := 3.0      # duração do efeito em segundos

func _on_body_entered(body: Node):
	if body.is_in_group("player"):   # garanta que seu Player esteja no grupo "player"
		Global.health = move_toward(Global.health, Global.health_max, heal_bonus)
		print("Heal:", Global.health)
		$CollisionShape2D.queue_free()
		$Sprite2D.queue_free()

		await get_tree().create_timer(duration).timeout
		queue_free()  # remove o item da cenad
