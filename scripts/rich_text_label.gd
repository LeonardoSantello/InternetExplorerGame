extends RichTextLabel

@export var player: Node2D  # Arraste o jogador no editor ou defina por código
@export var min_distance: float = 100.0  # Distância onde o texto fica totalmente visível
@export var max_distance: float = 300.0  # Distância onde o texto fica totalmente invisível

func _process(_delta):
	if player == null:
		return

	# Calcular o centro do texto
	var label_center_x = global_position.x + (size.x * 0.5)
	var x_distance = abs(label_center_x - player.global_position.x)

	var alpha := 1.0
	if x_distance <= min_distance:
		alpha = 1.0
	elif x_distance >= max_distance:
		alpha = 0.0
	else:
		alpha = 1.0 - ((x_distance - min_distance) / (max_distance - min_distance))

	modulate.a = alpha
