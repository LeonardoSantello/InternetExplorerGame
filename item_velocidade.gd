extends Area2D

@export var speed_bonus := 200   # quanto aumenta a velocidade
@export var duration := 3.0      # duração do efeito em segundos

func _on_body_entered(body: CharacterBody2D):
	body.speed += speed_bonus      # aumenta a velocidade
	queue_free()                   # remove o item
	await get_tree().create_timer(duration).timeout
	body.speed -= speed_bonus      # volta a velocidade normal
