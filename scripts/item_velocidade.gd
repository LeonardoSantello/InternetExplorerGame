extends Area2D

@export var speed_bonus := 200   # quanto aumenta a velocidade
@export var duration := 3.0      # duração do efeito em segundos

func _on_body_entered(body: Node):
	if body.is_in_group("player"):   # garanta que seu Player esteja no grupo "player"
		Global.speed = Global.speed + speed_bonus
		print("Speed:", Global.speed)
		$CollisionShape2D.queue_free()
		$Sprite2D.queue_free()

		await get_tree().create_timer(duration).timeout
		Global.speed -= speed_bonus
		print("Speed:", Global.speed)
		queue_free()  # remove o item da cenad
