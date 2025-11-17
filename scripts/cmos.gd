extends CharacterBody2D
class_name CmosEnemy

const SPEED = 70
var dir: Vector2

@export var deathParticle : PackedScene 
var player: CharacterBody2D

var health = 50
var health_max = 50

var dead = false
var taking_damage = false


var is_chasing: bool = false
var is_roaming: bool = true
var patrol_area: Area2D
var patrol_left: float
var patrol_right: float

func _ready() -> void:
	Global.cmosDamageAmount = 20
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
		if is_chasing and not taking_damage:
			var direction_player = position.direction_to(player.position) * SPEED
			velocity.x = direction_player.x
			dir.x = sign(velocity.x)
		elif taking_damage:
			var knockback_dir = position.direction_to(player.position) * -150
			velocity.x = knockback_dir.x
			velocity.y = -25
		elif is_roaming:
			velocity.x = dir.x * SPEED
			if position.x <= patrol_left:
				dir.x = 1
			elif position.x >= patrol_right:
				dir.x = -1

		elif is_chasing:
			var direction_player = position.direction_to(player.position) * SPEED
			velocity.x = direction_player.x
			dir.x = sign(velocity.x)
	else:
		velocity.x = 0

func _on_timer_timeout():
	$Timer.wait_time = randf_range(2, 4)
	if not is_chasing:
		dir = choose([Vector2.RIGHT, Vector2.LEFT])
		velocity.x = 0

func choose(array):
	array.shuffle()
	return array.front()
	
func handle_animation():
	var sprite = $Sprite2D
	if not dead:
		if taking_damage:
			$AnimationPlayer.play("hurt")
			await get_tree().create_timer(0.3).timeout
			taking_damage = false
		else:
			$AnimationPlayer.play("walk")
			if dir.x != 0:
				sprite.flip_h = dir.x < 0
	else:
		$AnimationPlayer.play("dead")
		$cmosHitBox/CollisionShape2D.disabled = true # Desliga hitbox para não dar mais dano
		
		await get_tree().create_timer(1).timeout
		deathParticleFunc()
		# Chama a função de morte (atualiza o bestiário)
		_on_death()
		
		print(str(self), "Morreu")
		self.queue_free()

func _on_cmos_hit_box_area_entered(area):
	if area == Global.playerDamageZone and not taking_damage:
		var damage = Global.playerDamageAmount
		take_damage(damage)

func take_damage(damage):
	health -= damage
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


func _on_death():
	if typeof(BestiaryData) != TYPE_NIL:
		BestiaryData.add_kill("cmos")
	else:
		print("⚠️ BestiaryData não encontrado — inimigo morreu mas não foi registrado no bestiário.")

		
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
