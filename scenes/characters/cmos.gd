extends CharacterBody2D

const SPEED = 30
var player: CharacterBody2D
var dir: Vector2
var is_chasing: bool

var health = 50
var health_max = 50
var health_min = 0
var dead = false
var taking_damage = false
var is_roming: bool

func _process(delta):
	move(delta)
	handle_animation()
	
	if is_on_floor() and dead:
		await  get_tree().create_timer(3).timeout
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
			velocity = Vector2(dir_x, 0) * SPEED + (get_gravity() * delta)
			dir.x = abs(velocity.x) / velocity.x
		elif taking_damage:
			var knockback_dir = position.direction_to(player.position) * -150
			velocity = knockback_dir
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
		
	
