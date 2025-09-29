extends Node2D

@onready var scene_transition_animation = $Player/sceneTransitionAnimation/AnimationPlayer

func  _ready():
	scene_transition_animation.play("fade_out")
func _on_next_level_body_entered(body):
	if body is Player:
		scene_transition_animation.play("fade_in")
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://scenes/levels/test_area2.tscn")
