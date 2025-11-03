extends Node2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("entrou")
	if body.is_in_group("player"): 
		$melt.play("melt")


func _on_melt_animation_finished(_anim_name: StringName) -> void:
	$"../Player/Camera2D/CanvasLayer/dash_icon/Sprite2D/AnimationPlayer".play("melt")
	await get_tree().create_timer(0.2).timeout
	$"../Player/Camera2D/CanvasLayer/dash_icon".visible = true
	await get_tree().create_timer(0.8).timeout
	print("Ativou dash")
	$"../Player".can_dash = true
	queue_free()  
