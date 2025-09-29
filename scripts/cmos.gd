extends CharacterBody2D

class_name CmosEnemy

const SPEED = 30
var dir: Vector2

var is_chasing: bool

var player: CharacterBody2D

var health = 50
var health_max = 50
var health_min = 0

var dead = false
var taking_damage = false
var is_roming: bool
var damage_to_deal = 20

func _process(delta):
	Global.cmosDamageAmount = damage_to_deal
	move(delta)
	handle_animation()

	if is_on_floor() and dead:
		$cmosHitBox.monitorable = false #Desliga hitbox para não poder dar mais dano
		await  get_tree().create_timer(1).timeout
		print(str(self), "Morreu")
		self.queue_free()
		await  get_tree().create_timer(0.1).timeout

func _ready():
	is_chasing = true

func move(delta):

	player = Global.playerBody
	if not dead:
		is_roming = true
		if is_chasing and not taking_damage:
			var dir_x = sign(player.position.x - position.x)
			# Movimento horizontal (segue o player)
			velocity.x = dir_x * SPEED
			# Movimento vertical (gravidade)
			velocity += get_gravity() * delta
			# Atualiza a direção do sprite (esquerda/direita)
			dir.x = sign(velocity.x)
		elif taking_damage:
			var knockback_dir = position.direction_to(player.position) * -150
			velocity = knockback_dir
			velocity.y = -25
		else:
			velocity += dir * SPEED * delta
	elif dead:
		velocity.y += 10 * delta
		velocity.x = 0
	move_and_slide()

func _on_timer_timeout():
	$Timer.wait_time = choose([1.0, 1.5, 2.0])
	if not is_chasing:
		dir = choose([Vector2.RIGHT, Vector2.LEFT])

func choose(array):
	array.shuffle()
	return array.front()
	
func handle_animation():
	var sprite = $Sprite2D
	if not dead and not taking_damage:
		$AnimationPlayer.play("walk")
		if dir.x == -1:
			sprite.flip_h = true
		elif dir.x == 1:
			sprite.flip_h = false
	elif not dead and taking_damage:
		$AnimationPlayer.play("hurt")
		await  get_tree().create_timer(0.3).timeout
		taking_damage = false
	elif dead and is_roming:
		print("dead")
		is_roming = false
		$AnimationPlayer.play("dead")


func _on_cmos_hit_box_area_entered(area):
	if area == Global.playerDamageZone:
		var damage = Global.playerDamageAmount
		take_damage(damage)

func take_damage(damage):
	health -= damage
	print(str(self), "Vida:", health)
	taking_damage = true
	if health <= 0:
		health = 0
		dead = true
		
	
