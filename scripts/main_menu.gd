extends Control

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Global.reset_game_state()

func _on_button_pressed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$transition.scene_transition_animation_function("res://scenes/levels/kernel_cut.tscn")


func _on_button_3_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/opcoes.tscn")


func _on_button_2_pressed() -> void:
	get_tree().quit()
