extends Area2D

@export var speed_bonus := 200   # quanto aumenta a velocidade
@export var duration := 3.0      # duração do efeito em segundos

func _on_body_entered(body: Node):
	if body.is_in_group("player"):   # garanta que seu Player esteja no grupo "player"
		var original_speed = body.speed
		body.speed = original_speed + speed_bonus

		queue_free()  # remove o item da cena

		await get_tree().create_timer(duration).timeout

		
		body.speed = original_speed
