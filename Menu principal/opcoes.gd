extends Control



func _ready() -> void:
	pass 



func _process(_delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Menu principal/main_menu.tscn")
