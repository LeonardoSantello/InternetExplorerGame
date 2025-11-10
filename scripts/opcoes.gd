extends Control

@export
var bus_name: String

var bus_index: int

func _ready() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/main_menu.tscn")

func _on_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(
		bus_index,
		linear_to_db(value)
	)


func _on_facil_pressed() -> void:
	Global.health_max = 150
	Global.health = 150
	
	$Botoes/facil.disabled = true
	$Botoes/normal.disabled = false
	$Botoes/dificil.disabled = false

func _on_normal_pressed() -> void:
	Global.health_max = 100
	Global.health = 100
	
	$Botoes/facil.disabled = false
	$Botoes/normal.disabled = true
	$Botoes/dificil.disabled = false

func _on_dificil_pressed() -> void:
	Global.health_max = 50
	Global.health = 50
	
	$Botoes/facil.disabled = false
	$Botoes/normal.disabled = false
	$Botoes/dificil.disabled = true
