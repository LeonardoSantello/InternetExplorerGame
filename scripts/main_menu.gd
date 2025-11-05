extends Control

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	Global.reset_game_state()

func _on_button_pressed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$transition.scene_transition_animation_function("res://scenes/levels/kernel_cut.tscn")


func _on_button_3_pressed() -> void:
	$transition.scene_transition_animation_function("res://scenes/levels/opcoes.tscn")


func _on_button_2_pressed() -> void:
	get_tree().quit()
