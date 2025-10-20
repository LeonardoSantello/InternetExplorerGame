extends CharacterBody2D

class_name inimigo_basico

const SPEED = 30
var is_chasing: bool = true

var health = 80

var dead: bool = false
var taking_damage: bool = false
var is_dealing_damge: bool = false

var dir: Vector2
var knockback_force = 200
var is_roaming: bool = true

var player: CharacterBody2D
var player_in_area = false

func _ready() -> void:
	Global.inimigoBasicoDamageAmount = 1
	
func _physics_process(delta) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		velocity.x = 0
		
	player = Global.playerBody
	move(delta)
	handle_animation()
	move_and_slide()

func move(delta):
	if not dead:
		if not is_chasing:
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
	if not dead and not taking_damage and not is_dealing_damge:
		animation.play("walk")
		if dir.x != 0:
			$AnimatedSprite2D.flip_h = dir.x < 0
	elif not dead and taking_damage:
		animation.play("hurt")
		await get_tree().create_timer(0.3).timeout
		taking_damage = false
	elif dead and is_roaming:
		is_roaming = false
		animation.play("dead")
		$hitBox/CollisionShape2D.disabled = true
		await  get_tree().create_timer(1).timeout
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
	taking_damage = true
	if health <= 0:
		health = 0
		dead = true
