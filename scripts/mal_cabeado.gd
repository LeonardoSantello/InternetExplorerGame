extends CharacterBody2D

class_name mal_cabeado

const SPEED = 30
const GRAVITY = 900
var is_chasing: bool = true

var health = 80
var health_max = 80

var dead: bool = false
var taking_damage: bool = false
var is_dealing_damage: bool = false
var attack_cooldown: bool = false

var dir: Vector2
var knockback_force = 200
var is_roaming: bool = true

var player: CharacterBody2D
var player_in_area = false

func _ready() -> void:
	Global.malCabeadoDamageAmount = 20
	
func _process(delta) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		velocity.x = 0
		
	player = Global.playerBody
	move(delta)
	handle_animation()
	move_and_slide()

func move(delta):
	if not dead:
		if is_dealing_damage:
			velocity.x  = move_toward(velocity.x, 0, SPEED)
		elif not is_chasing:
			velocity += dir * SPEED * delta
		elif is_chasing and not taking_damage:
			var direction_player = position.direction_to(player.position) * SPEED
			velocity.x = direction_player.x
			dir.x = sign(velocity.x)
		elif taking_damage:
			var knockback_dir = position.direction_to(player.position) * -150
			velocity = knockback_dir
			velocity.y = -25

		is_roaming = true
			
	elif dead:
		velocity.x = 0

func handle_animation():
	var animation = $AnimationPlayer
	if not dead and not taking_damage and not is_dealing_damage:
		animation.play("walk")
		if dir.x != 0:
			$AnimatedSprite2D.flip_h = dir.x < 0
	elif is_dealing_damage:
		animation.play("attack")
	elif not dead and taking_damage:
		animation.play("hurt")
		await get_tree().create_timer(0.3).timeout
		taking_damage = false
	elif dead and is_roaming:
		is_roaming = false
		animation.play("dead")
		#$CollisionShape2D.monitorable = false #Desliga hitbox para não poder dar mais dano
		await get_tree().create_timer(1).timeout
		print(str(self), "Morreu")
		self.queue_free()
		
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
	print(str(self), "Vida:", health)
	taking_damage = true
	if health <= 0:
		health = 0
		dead = true


func _on_cabo_area_entered(area: Area2D) -> void:
	if area == Global.playerHitBox and attack_cooldown == false:
		attack_cooldown = true
		is_dealing_damage = true
		await get_tree().create_timer(1).timeout
		$cabo.play("cabo")
		print("Com dano")
		$Cabo.monitorable = true


func _on_animation_player_animation_finished(_anim_name = "attack") -> void:
	print("Sem dano")
	$Cabo.monitorable = false
	is_dealing_damage = false
	$"Attack Cooldown".start()

func _on_attack_cooldown_timeout() -> void:
	print("Mal cabeamento terminou o attack_cooldown")
	attack_cooldown = false
