extends Node2D

func _on_next_level_body_entered(body) -> void:
	if body is Player:
		$Player/Camera2D/CanvasLayer/transitionAnimation.scene_transition_animation_function("res://scenes/levels/test_area2.tscn")
