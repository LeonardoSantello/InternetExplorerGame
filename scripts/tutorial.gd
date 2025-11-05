extends Node2D


func _ready() -> void:
	$Player/Camera2D/CanvasLayer/dash_icon.visible = false
	$Player.can_dash = false
	$Player.can_slide = false
	$Player.max_jumps = 1

func _process(_delta: float) -> void:
	pass


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area == Global.playerHitBox:
		print("Ativou pulo dupo")
		$Player.max_jumps = 2
		$areas2D/Area2D.queue_free()


func _on_area_2d_3_area_entered(area: Area2D) -> void:
	if area == Global.playerHitBox:
		print("Ativou slide")
		$Player.can_slide = true
		$areas2D/Area2D3.queue_free()


func _on_next_level_area_entered(area: Area2D) -> void:
	if area == Global.playerHitBox:
		$Player/Camera2D/CanvasLayer/transitionAnimation.scene_transition_animation_function("res://scenes/levels/bios/lvl1.tscn")


func _on_porta_2_area_entered(area: Area2D) -> void:
	if area == Global.playerHitBox:
		$porta2/AnimationPlayer.play("move")
