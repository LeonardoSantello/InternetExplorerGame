extends CharacterBody2D
class_name invader

var dir: Vector2
@export var deathParticle : PackedScene 
var speed: float = 100.0

var health: int = 10
var dead: bool = false

var player: CharacterBody2D

func _ready() -> void:
	Global.invaderDamageAmount = 15
	player = Global.playerBody
	dir = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()


func _physics_process(_delta: float) -> void:
	if dead:
		velocity = Vector2.ZERO
	else:
		move()
	
	move_and_slide()
	handle_animation()


func move() -> void:
	velocity = dir * speed
	
	if is_on_wall() or is_on_ceiling() or is_on_floor():
		dir = -dir * 0.2
		velocity = dir * speed


func _on_direction_timer_timeout() -> void:
	if dead:
		return
	
	var angle_change = randf_range(PI/2,-PI/2)
	dir = dir.rotated(angle_change).normalized()
	$directionTimer.start()


func handle_animation() -> void:
	var animation = $AnimationPlayer
	
	if dead:
		$hitBox/CollisionShape2D.disabled = true
		await get_tree().create_timer(0.1).timeout
		deathParticleFunc()
		_on_death()
		queue_free()
	else:
		animation.play("walk")


func deathParticleFunc():
	var _particle = deathParticle.instantiate()
	_particle.position = global_position
	_particle.rotation = global_rotation
	_particle.emitting = true
	get_tree().current_scene.add_child(_particle)


func _on_hit_box_area_entered(area: Area2D) -> void:
	if area == Global.playerDamageZone:
		var damage = Global.playerDamageAmount
		take_damage(damage)

func take_damage(damage: int) -> void:
	health -= damage
	print(health)
	if health <= 0:
		health = 0
		dead = true
		
func _on_death():
	# Evita erro se o autoload não estiver carregado ainda
	if Engine.has_singleton("BestiaryData"):
		var bestiary = Engine.get_singleton("BestiaryData")
		bestiary.add_kill("virus")
	elif typeof(BestiaryData) != TYPE_NIL:
		# Caso BestiaryData seja um autoload declarado com "BestiaryData"
		BestiaryData.add_kill("virus")
	else:
		print("⚠️ BestiaryData não encontrado — inimigo morreu mas não foi registrado no bestiário.")
