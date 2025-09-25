extends Control


func _ready() -> void:
	pass 



func _process(_delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/test_area.tscn")


func _on_button_3_pressed() -> void:
	get_tree().change_scene_to_file("res://Menu principal/opcoes.tscn")


func _on_button_2_pressed() -> void:
	get_tree().quit()
