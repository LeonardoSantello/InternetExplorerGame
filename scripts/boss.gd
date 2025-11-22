extends CharacterBody2D

class_name boss
@export var deathParticle : PackedScene 

var health = 200
var health_max = 200
var dir: Vector2
var dead: bool = false
var taking_damage: bool = false
var is_dealing_damge: bool = false
var move_cooldown: bool = false
var move: int = 4
var last_move: int = 4

func _ready() -> void:
	
	dir = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	Global.bossDamageAmount = 10
	
func _physics_process(_delta) -> void:
	if Global.boss_started and move_cooldown == false:
		move_cooldown = true
		while last_move == move:
			move = randi_range(1, 4)
		last_move = move
		#move = 3
		await get_tree().create_timer(2).timeout
		if move == 1 and !dead:
			$LaserPowerUpBMinor.play()
			await get_tree().create_timer(1.0).timeout
			$moves.play("laser1")
		elif move == 2 and !dead:
			$LaserPowerUpBMinor.play()
			await get_tree().create_timer(0.5).timeout
			$LaserPowerUpBMinor.play()
			await get_tree().create_timer(0.5).timeout
			$moves.play("laser2")
		elif move == 3 and !dead:
			for i in 20:
				$ZapC0782067.play()
				shoot_folder()
			await get_tree().create_timer(1.5).timeout
			for i in 20:
				$ZapC0782067.play()
				shoot_folder()
			await get_tree().create_timer(1.5).timeout
			for i in 20:
				$ZapC0782067.play()
				shoot_folder()
		elif move == 4 and !dead:
			$"8BitExplosion95847".play()
			shoot_x()
		
		$Timer.start()
	
	handle_animation()

func handle_animation():
	var animation = $AnimationPlayer
	
	if !Global.boss_started:
		$AnimatedSprite2D.play("damage")
	elif not dead and taking_damage:
		$AnimatedSprite2D.play("damage")
		animation.play("hurt")
		await get_tree().create_timer(0.3).timeout
		taking_damage = false
	elif dead:
		$AnimatedSprite2D.play("damage")
		$"../RayCast2D".is_casting = false
		$"../RayCast2D2".is_casting = false
		animation.play("dead")
		$hitBox/CollisionShape2D.disabled = true
		await  get_tree().create_timer(4).timeout
		print(str(self), "Morreu")
		deathParticleFunc()
		var big_file = preload("res://scenes/itens/end_file.tscn")
		var new_enemy = big_file.instantiate()
		new_enemy.position = position 
		get_parent().add_child(new_enemy)

		self.queue_free()
	else:
		$AnimatedSprite2D.play("idle")

func take_damage(damage):
	health -= damage
	taking_damage = true
	if health <= 100:
		health = 0
		dead = true
		
func deathParticleFunc():
	var _particle = deathParticle.instantiate()
	_particle.position = global_position
	_particle.rotation = global_rotation
	_particle.emitting = true
	get_tree().current_scene.add_child(_particle)


func _on_timer_timeout() -> void:
	move_cooldown = false

var folder_node = preload("res://scenes/others/folder_attack.tscn")
func shoot_folder():
	var bullet = folder_node.instantiate()
	var offset = Vector2(randf_range(-100, 100), randf_range(-100, 100))
	bullet.position = $".".position + offset
	get_tree().current_scene.add_child(bullet)
	
var x_node = preload("res://scenes/others/x_attack.tscn")
func shoot_x():
	var bullet = x_node.instantiate()
	var offset = Vector2(randf_range(-70, 70), randf_range(-70, 70))
	bullet.position = $".".position + offset
	get_tree().current_scene.add_child(bullet)
