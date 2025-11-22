extends Node2D


func _on_animation_player_animation_finished(_anim_name = "death") -> void:
	Global.reset_game_state()
	$VideoStreamPlayer.play()


func _on_video_stream_player_finished() -> void:
	Global.reset_game_state()
	$"../transitionAnimation".scene_transition_animation_function("res://scenes/levels/main_menu.tscn")
