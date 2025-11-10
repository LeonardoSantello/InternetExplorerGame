extends Area2D

@onready var file_text = $"../../Player/Camera2D/CanvasLayer/file/file_text"
@onready var file_anim = $"../../Player/Camera2D/CanvasLayer/file/file_animation"
#$"../../Player"file_animation
func _on_body_entered(_body) -> void:
		Global.files_coleted += 1
		print(Global.files_coleted)
		
		$AnimatedSprite2D.queue_free()
		$CollisionShape2D.queue_free()
		file_text.text = "[font=res://assets/fonts/Px437_IBM_BIOS.ttf]" + str(Global.files_coleted) + "[/font]"
		file_anim.stop()
		file_anim.play("move")
		$sfx_coin.play() 
		await $sfx_coin.finished
		queue_free()                               
