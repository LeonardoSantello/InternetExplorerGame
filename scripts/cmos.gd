extends CharacterBody2D

class_name CmosEnemy

const SPEED = 70
var dir: Vector2

var is_chasing: bool = true

var player: CharacterBody2D

var health = 50
var health_max = 50

var dead = false
var taking_damage = false
var is_roming: bool


func _ready() -> void:
	Global.cmosDamageAmount = 20
	
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
		is_roming = true
		if is_chasing and not taking_damage:
			var direction_player = position.direction_to(player.position) * SPEED
			velocity.x = direction_player.x
			dir.x = sign(velocity.x)
		elif taking_damage:
			var knockback_dir = position.direction_to(player.position) * -150
			velocity.x = knockback_dir.x
			velocity.y = -25
		else:
			velocity += dir * SPEED * delta
	elif dead:
		velocity.y += 10 * delta
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
	if not dead and not taking_damage:
		$AnimationPlayer.play("walk")
		if dir.x != 0:
			sprite.flip_h = dir.x < 0
	elif not dead and taking_damage:
		$AnimationPlayer.play("hurt")
		await  get_tree().create_timer(0.3).timeout
		taking_damage = false
	elif dead and is_roming:
		is_roming = false
		$AnimationPlayer.play("dead")
		$cmosHitBox.monitorable = false #Desliga hitbox para não poder dar mais dano
		await  get_tree().create_timer(1).timeout
		print(str(self), "Morreu")
		self.queue_free()


func _on_cmos_hit_box_area_entered(area):
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
		
	
