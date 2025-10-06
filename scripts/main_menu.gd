extends Control

func _ready() -> void:
	Global.reset_game_state()

func _on_button_pressed() -> void:
	$transition.scene_transition_animation_function("res://scenes/levels/test_area.tscn")


func _on_button_3_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/opcoes.tscn")


func _on_button_2_pressed() -> void:
	get_tree().quit()
