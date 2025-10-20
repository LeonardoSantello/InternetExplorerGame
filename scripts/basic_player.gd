extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var slow: bool = false
var stop: bool = false
var fast: bool = false

func _ready() -> void:
	velocity.y = 1000

func _physics_process(delta):
	if fast:
		$AnimatedSprite2D/AnimationPlayer.play("jump")
		velocity.y = move_toward(velocity.y, 2000, (gravity * delta)/2)
	elif stop:
		$AnimatedSprite2D/AnimationPlayer.stop()
		await get_tree().create_timer(1).timeout
		$AnimatedSprite2D/AnimationPlayer.play("jump")
		gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
		velocity.y = 2000
		fast = true
	elif slow:
		pass
	elif not is_on_floor():
		$AnimatedSprite2D/AnimationPlayer.play("jump")
		velocity.y = move_toward(velocity.y, 3000, (gravity * delta)/2)

	move_and_slide()


func _on_slow_timeout() -> void:
	$"../WindArtificial8Bit".pitch_scale = 0.7
	gravity = 0
	velocity.y = 500
	$stop.start()
	slow = true


func _on_stop_timeout() -> void:
	$"../WindArtificial8Bit".stop()
	stop = true
	print("Para")
	velocity.y = 0


func _on_area_2d_body_entered(_body: CharacterBody2D) -> void:
	#await get_tree().create_timer(0.1).timeout
	$Camera2D/CanvasLayer/ColorRect.visible = true
	$"../FastBodyFallImpact8Bit".play()
	await get_tree().create_timer(2).timeout
	$"../transition".scene_transition_animation_function("res://scenes/levels/kernel_level.tscn")
