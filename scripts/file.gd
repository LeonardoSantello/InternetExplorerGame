extends Area2D

func _on_body_entered(_body) -> void:
		Global.files_coleted += 1
		print(Global.files_coleted)
		
		$AnimatedSprite2D.queue_free()
		$CollisionShape2D.queue_free()
		
		$sfx_coin.play() 
		
		await $sfx_coin.finished
		queue_free()                               
