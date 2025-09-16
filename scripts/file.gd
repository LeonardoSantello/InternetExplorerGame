extends Area2D

func _on_body_entered(body):
		get_parent().get_node("sfx_coin").play()  # toca o som do node pai
		queue_free()                               
