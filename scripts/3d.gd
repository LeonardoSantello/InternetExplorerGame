extends Node2D

func _on_video_stream_player_finished() -> void:
	$CanvasLayer/transition.scene_transition_animation_function("res://scenes/levels/kernel_cut.tscn")
