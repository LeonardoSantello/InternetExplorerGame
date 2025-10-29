extends Node2D

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area == Global.playerHitBox:
		$Player/Camera2D/CanvasLayer/transitionAnimation.scene_transition_animation_function("res://scenes/levels/bios/lvl2.tscn")


func _on_porta_area_entered(area: Area2D) -> void:
	if area == Global.playerHitBox:
		$plataformas/plataformas_ultima_parte/porta/porta2.play("porta")
		

func _on_porta_2_animation_finished(_anim_name: StringName) -> void:
	$plataformas/plataformas_ultima_parte/porta.queue_free()
