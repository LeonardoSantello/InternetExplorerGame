extends Node2D

func _ready() -> void:
	$porta/boss/RigidBody2D/CollisionShape2D.disabled = true

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area == Global.playerHitBox:
		$porta/boss/AnimationPlayer.play("door")
		$porta/boss/Area2D.queue_free()
