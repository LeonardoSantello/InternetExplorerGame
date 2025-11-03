extends CharacterBody2D
class_name mal_cabeado

const SPEED = 60

var health = 80
var health_max = 80

var dead: bool = false
var taking_damage: bool = false
var is_dealing_damage: bool = false
var attack_cooldown: bool = false

@export var deathParticle : PackedScene 
var dir: Vector2
var player: CharacterBody2D

var is_chasing: bool = false
var is_roaming: bool = true
var patrol_area: Area2D
var patrol_left: float
var patrol_right: float

func _ready() -> void:
	Global.malCabeadoDamageAmount = 20
	call_deferred("patrolArea")
	
func _physics_process(delta) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		velocity.x = 0
		
	player = Global.playerBody
	move()
	handle_animation()
	move_and_slide()

func move():
	if not dead:
		if is_dealing_damage:
			velocity.x  = move_toward(velocity.x, 0, SPEED)
		elif taking_damage:
			var knockback_dir = position.direction_to(player.position) * -150
			velocity = knockback_dir
			velocity.y = -25
		elif is_chasing:
			var direction_player = position.direction_to(player.position) * SPEED
			velocity.x = direction_player.x
			dir.x = sign(velocity.x)
		elif is_roaming:
			velocity.x = dir.x * SPEED
			if position.x <= patrol_left:
				dir.x = 1
			elif position.x >= patrol_right:
				dir.x = -1
	elif dead:
		velocity.x = 0

func handle_animation():
	var animation = $AnimationPlayer
	if is_dealing_damage:
		animation.play("attack")
	elif not dead and taking_damage:
		animation.play("hurt")
		await get_tree().create_timer(0.3).timeout
		taking_damage = false
	elif dead:
		animation.play("dead")
		$hitBox/CollisionShape2D.disabled = true
		$Cabo.monitoring = false
		$Cabo.monitorable = false
		await get_tree().create_timer(1).timeout
		deathParticleFunc()
		print(str(self), "Morreu")
		self.queue_free()
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


func _on_hit_box_area_entered(area: Area2D) -> void:
	if area == Global.playerDamageZone and not taking_damage:
		var damage = Global.playerDamageAmount
		take_damage(damage)

func take_damage(damage):
	health -= damage
	print("DAmage")
	taking_damage = true
	if health <= 0:
		health = 0
		dead = true

func deathParticleFunc():
	var _particle = deathParticle.instantiate()
	_particle.position = global_position
	_particle.rotation = global_rotation
	_particle.emitting = true
	get_tree().current_scene.add_child(_particle)

func _on_cabo_area_entered(area: Area2D) -> void:
	if area == Global.playerHitBox and attack_cooldown == false:
		attack_cooldown = true
		is_dealing_damage = true
		await get_tree().create_timer(1).timeout
		$cabo.play("cabo")
		$Cabo.monitorable = true


func _on_animation_player_animation_finished(anim_name: String) -> void:
	if anim_name != "attack":
		return
		
	taking_damage = false
	$Cabo.monitorable = false
	is_dealing_damage = false
	$"Attack Cooldown".start()

func _on_attack_cooldown_timeout() -> void:
	print("Mal cabeamento terminou o attack_cooldown")
	attack_cooldown = false
	
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
