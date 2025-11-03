extends Node2D

func _on_next_lvl_area_entered(area: Area2D) -> void:
	if area == Global.playerHitBox:
		$Player/Camera2D/CanvasLayer/transitionAnimation.scene_transition_animation_function("res://scenes/levels/bios/lvl3.tscn")
