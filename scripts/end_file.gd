extends Area2D


func _on_body_entered(_body) -> void:
		Global.files_coleted += 1
		print(Global.files_coleted)
		
		$AnimatedSprite2D.queue_free()
		$CollisionShape2D.queue_free()
		$"../Player/Camera2D/CanvasLayer/transitionAnimation".scene_transition_animation_function("res://scenes/others/creditos.tscn")
		queue_free()                               
