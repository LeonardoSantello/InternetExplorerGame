extends Node2D

@onready var animation: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	#await get_tree().create_timer(0.5).timeout
	animation.play("fade_out")

func scene_transition_animation_function(scene_path: String):
	animation.play("fade_in")
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file(scene_path)
