extends CharacterBody2D
class_name cavaloDeTroia

const DASH_SPEED = 500

var speed = 100
var dir: Vector2

var health = 80
var dead: bool = false
var taking_damage: bool = false

var is_chasing: bool = false
var is_roaming: bool = true
var patrol_area: Area2D
var patrol_left: float
var patrol_right: float

var player: CharacterBody2D

var is_dashing: bool = false
@onready var dash_timer: Timer = $dash_timer
@onready var dash_cooldown_timer: Timer = $dash_cooldown_timer
@export var deathParticle : PackedScene 

func _ready() -> void:
	Global.cavaloDeTroiaDamageAmount = 30
	dash_cooldown_timer.start()
	call_deferred("patrolArea")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		velocity.x = 0
		
	player = Global.playerBody
	move()
	handle_animation()
	move_and_slide()

func move() -> void:
	if dead:
		velocity.x = 0
		return

	if taking_damage and not is_dashing:
		var knockback_dir = position.direction_to(player.position) * -150
		velocity = knockback_dir
		velocity.y = -25
		return

	if is_dashing:
		return

	if is_roaming:
		velocity.x = dir.x * speed
		if position.x <= patrol_left:
			dir.x = 1
		elif position.x >= patrol_right:
			dir.x = -1

	elif is_chasing:
		var direction_player = position.direction_to(player.position) * speed
		velocity.x = direction_player.x
		dir.x = sign(velocity.x)


func handle_animation():
	var animation = $AnimationPlayer
	if dead:
		is_roaming = false
		animation.play("dead")
		$hitBox/CollisionShape2D.disabled = true
		await get_tree().create_timer(1).timeout
		deathParticleFunc()
			
		#Spawna novo inimigo
		var new_enemy_scene = preload("res://scenes/characters/invaderLifeTime.tscn")
		var new_enemy = new_enemy_scene.instantiate()
		var new_enemy1 = new_enemy_scene.instantiate()
		var new_enemy2 = new_enemy_scene.instantiate()
		new_enemy.position = position 
		new_enemy1.position = position 
		new_enemy2.position = position 
		get_parent().add_child(new_enemy)
		get_parent().add_child(new_enemy1)
		get_parent().add_child(new_enemy2)

		queue_free()
		return
	elif taking_damage:
		animation.play("hurt")
		await get_tree().create_timer(0.3).timeout
		taking_damage = false
		return
	elif $dash_cooldown_timer.time_left < 1 and $dash_cooldown_timer.time_left > 0 and is_chasing:
		speed = 0
		animation.play("will_dash")
		return
	elif is_dashing:
		animation.play("dash")
		return
	else:
		animation.play("walk")
	if dir.x != 0:
			$AnimatedSprite2D.flip_h = dir.x < 0


func _on_timer_timeout() -> void:
	$DirectionTimer.wait_time = randf_range(2, 4)
	if not is_chasing:
		dir = choose([Vector2.RIGHT, Vector2.LEFT])
		velocity.x = 0


func choose(array):
	array.shuffle()
	return array.front()


func deathParticleFunc():
	var _particle = deathParticle.instantiate()
	_particle.position = global_position
	_particle.rotation = global_rotation
	_particle.emitting = true
	get_tree().current_scene.add_child(_particle)

func _on_hit_box_area_entered(area: Area2D) -> void:
	if area == Global.playerDamageZone and not taking_damage:
		var damage = Global.playerDamageAmount
		take_damage(damage)


func take_damage(damage):
	health -= damage
	taking_damage = true
	if health <= 0:
		health = 0
		dead = true

# ==============================
# DASH
# ==============================
func _on_dash_timer_timeout() -> void:
	if is_chasing or speed == 0:
		speed = 50
		is_dashing = false
		velocity = Vector2.ZERO
		print(self,"Terminou dash.")
	dash_cooldown_timer.start()


func _on_dash_cooldown_timer_timeout() -> void:
	if is_chasing or speed == 0:
		is_dashing = true
		var dash_dir = Vector2(player.position.x - position.x, 0).normalized()
		if dash_dir.x != 0:
				$AnimatedSprite2D.flip_h = dash_dir.x < 0
		velocity = dash_dir * DASH_SPEED
		print(self,"Iniciou dash!")
	dash_timer.start()

# ==============================
# PERSEGUIÇÃO
# ==============================

func patrolArea():
	patrol_area = $DetectionArea
	var global_patrol_pos = patrol_area.global_position
	patrol_area.reparent(get_tree().current_scene)

	var patrol_shape = patrol_area.get_node("CollisionShape2D").shape
	if patrol_shape is RectangleShape2D:
		patrol_left = global_patrol_pos.x - patrol_shape.size.x / 2
		patrol_right = global_patrol_pos.x + patrol_shape.size.x / 2


func _on_detection_area_area_entered(body: Area2D) -> void:
	if body == Global.playerHitBox:
		print("Player dentro da area de perseguição")
		is_chasing = true
		is_roaming = false


func _on_detection_area_area_exited(body: Area2D) -> void:
	if body == Global.playerHitBox:
		print("Player fora da area de perseguição")
		is_chasing = false
		is_roaming = true
