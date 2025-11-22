extends Node2D
var was_speed: float
func _ready() -> void:
	$ServerRoom.play()
	$porta/boss/RigidBody2D/CollisionShape2D.disabled = true
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area == Global.playerHitBox:
		$porta/boss/AnimationPlayer.play("door")
		$porta/boss/Area2D.queue_free()


func _on_area_2d_4_area_entered(area: Area2D) -> void:
	if area == Global.playerHitBox:
		
		$ServerRoom.stop()
		$itens/RigidBody2D.queue_free()
		$itens/Area2D4.queue_free()
		was_speed = Global.speed
		$Player.can_dash = false
		$plataforms/StaticBody2D2/CollisionShape2D.position.x = 2543.0
		$plataforms/StaticBody2D2/CollisionShape2D.position.y = -1050.0
		Global.speed = 0
		Global.speed = 0
		Global.speed = 0
		Global.speed = 0
		Global.speed = 0
		Global.speed = 0
		await get_tree().create_timer(0.05).timeout
		Global.speed = 0
		await get_tree().create_timer(0.05).timeout
		Global.speed = 0
		await get_tree().create_timer(0.05).timeout
		Global.speed = 0
		await get_tree().create_timer(0.05).timeout
		Global.speed = 0
		await get_tree().create_timer(0.05).timeout
		Global.speed = 0
		await get_tree().create_timer(0.05).timeout
		Global.speed = 0
		await get_tree().create_timer(0.05).timeout
		Global.speed = 0
		await get_tree().create_timer(0.05).timeout
		Global.speed = 0
		await get_tree().create_timer(0.05).timeout
		Global.speed = 0
		await get_tree().create_timer(0.05).timeout
		Global.speed = 0
		await get_tree().create_timer(0.05).timeout
		Global.speed = 0
		await get_tree().create_timer(0.05).timeout
		Global.speed = 0
		await get_tree().create_timer(0.05).timeout
		Global.speed = 0
		await get_tree().create_timer(0.05).timeout
		Global.speed = 0
		await get_tree().create_timer(0.05).timeout
		Global.speed = 0
		await get_tree().create_timer(0.05).timeout
		Global.speed = 0
		await get_tree().create_timer(1).timeout
		Global.boss_started = true
		$Player.shaking = true
		$boss/EpicDragonRoar364481.play()
		Global.speed = Global.max_speed
		$Player.can_dash = true
		
		$plataforms/StaticBody2D.queue_free()
		$plataforms/StaticBody2D2.queue_free()
		
		await get_tree().create_timer(2).timeout
		$Player.shaking = false
		$"boss/Raphael'sFinalAct8BitsRemix(baldur'sGate3)".play()
