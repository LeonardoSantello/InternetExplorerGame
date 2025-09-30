extends CharacterBody2D

class_name Player

# ==============================
# CONSTANTES
# ==============================
const JUMP_VELOCITY = -465.0
const ATTACK_DURATION = 0.45
const MAX_JUMPS = 2    # pulo duplo
const WALL_SLIDE_SPEED = 50 # velocidade ao deslizar na parede


# ==============================
# VARIÁVEIS
# ==============================
@onready var deal_damage_zone: Area2D = $attack_area
@onready var anim: AnimatedSprite2D = $sprites/AnimatedSprite2D
@onready var dust_running: GPUParticles2D = $sprites/DustRunning
@onready var sfx_jump: AudioStreamPlayer2D = $audio/sfx_jump
@onready var sfx_run: AudioStreamPlayer2D = $audio/sfx_run
@onready var sfx_dash: AudioStreamPlayer2D = $audio/sfx_dash
@onready var sfx_attack: AudioStreamPlayer2D = $audio/sfx_attack

var speed = 300.0
var is_attacking: bool = false
var attack_timer: float = 0.0
var jumps_left: int = MAX_JUMPS
var wall_contact_time := 0.0
var is_wall_sliding := false
var jump_time := 0.0
var dash_cooldown := false
var attack: float = 10.0
var max_health: int = 100
var health: int = max_health

var can_take_damage: bool
var dead: bool

# ==============================
# FUNÇÕES PRINCIPAIS
# ==============================
func _ready():
	Global.playerBody = self
	dead = false
	can_take_damage = true
	Global.playerAlive = true

func _physics_process(delta: float):
	Global.playerDamageZone = deal_damage_zone
	
	if not dead:
		# ==============================
		# MOVIMENTAÇÃO
		# ==============================
		var direction := Input.get_axis("ui_left", "ui_right")
		if not is_attacking:
			if direction != 0:
				velocity.x = direction * speed
			else:
				velocity.x = move_toward(velocity.x, 0, speed)
		else:
			velocity.x = 0
			attack_timer -= delta
			if attack_timer <= 0:
				is_attacking = false
		
		move_and_slide()
		
		# ==============================
		# DETECTA INÍCIO / FIM DE CORRIDA
		# ==============================
		if direction != 0 and is_on_floor():
			# Poeira e som só quando começar a correr
			dust_running.emitting = true
			if not sfx_run.playing:
				sfx_run.play()
		elif (direction == 0 or not is_on_floor()):
			# Para poeira e som quando solta ou pula
			dust_running.emitting = false
			sfx_run.stop()

		# ==============================
		# ATAQUE
		# ==============================
		if Input.is_action_just_pressed("attack") and not is_attacking:
			is_attacking = true
			toggle_damage_collision()
			attack_timer = ATTACK_DURATION
			$sprites/AnimationPlayer.play("attack")
			$audio/sfx_attack.play()

		# ==============================
		# DASH
		# ==============================
		if Input.is_action_just_pressed("dash") and not dash_cooldown and not is_attacking and direction != 0:
			$timers/Dash.start()
			dash_cooldown = true
			speed *= 3
			velocity.x = direction * speed
			sfx_dash.play()

		# Gravidade
		if not is_on_floor():
			velocity += get_gravity() * delta
		else:
			jumps_left = MAX_JUMPS # reseta os pulos quando toca no chão
			if Input.is_action_just_pressed("down"):
				position.y += 5

		# ==============================
		# PULO E WALL JUMP
		# ==============================
		if Input.is_action_just_pressed("space") and not is_attacking:
			if is_wall_sliding:
				velocity.y = JUMP_VELOCITY
			elif jumps_left > 0:
				velocity.y = JUMP_VELOCITY
				jumps_left -= 1
				sfx_jump.play()

		# ==============================
		# WALL SLIDE
		# ==============================
		if is_on_wall_only():
			wall_contact_time += delta
			if wall_contact_time >= 0.3 and velocity.y > WALL_SLIDE_SPEED:
				is_wall_sliding = true
				velocity.y = WALL_SLIDE_SPEED
			else:
				is_wall_sliding = false
		else:
			wall_contact_time = 0.0
			is_wall_sliding = false

		# ==============================
		# ANIMAÇÕES
		# ==============================
		if not is_attacking:
			if is_wall_sliding:
				$sprites/AnimationPlayer.play("slide")
			elif speed > 500:
				$sprites/AnimationPlayer.play("dash")
			elif not is_on_floor():
				jump_time += delta
				if jump_time >= 0.2:
					$sprites/AnimationPlayer.play("jump")
			elif direction != 0:
				if direction < 0:
					$sprites/AnimationPlayer.play("run_left")
				else:
					$sprites/AnimationPlayer.play("run_right")
			else:
				jump_time = 0
				$sprites/AnimationPlayer .play("idle")

		# Espelhar sprite
		if direction < 0:
			anim.flip_h = true
			deal_damage_zone.scale.x = -1
		elif direction > 0:
			anim.flip_h = false
			deal_damage_zone.scale.x = 1
		check_hitbox()

func check_hitbox():
	var hitbox_areas = $hitBox.get_overlapping_areas()
	var damage: int
	if hitbox_areas:
		var hitbox = hitbox_areas.front()
		if hitbox.get_parent() is CmosEnemy:
			damage = Global.cmosDamageAmount
		
	if can_take_damage:
		take_damage(damage)
		
func take_damage(damage):
	if damage != 0:
		if Global.health > 0:
			Global.health -= damage
			print("Vida player:", Global.health)
			if Global.health <= 0:
				Global.health = 0
				dead = true
				Global.playerAlive = false
				handle_death_animation()
			take_damage_cooldown(1.0)

func handle_death_animation():
	await get_tree().create_timer(0.5).timeout
	$sprites/AnimationPlayer.play("death")
	$Camera2D.zoom.x = 4
	$Camera2D.zoom.y = 4
	await get_tree().create_timer(3.5).timeout

	get_tree().change_scene_to_file("res://scenes/levels/main_menu.tscn")
	

func take_damage_cooldown(wait_time):
	can_take_damage = false
	await get_tree().create_timer(wait_time).timeout
	can_take_damage = true
	

func toggle_damage_collision():
	var damage_zone_collision = deal_damage_zone.get_node("CollisionShape2D")
	damage_zone_collision.disabled = false
	await get_tree().create_timer(ATTACK_DURATION).timeout
	damage_zone_collision.disabled = true

func set_damage():
	var current_damage_to_deal: int
	current_damage_to_deal = 10
	Global.playerDamageAmount = current_damage_to_deal

func _on_dash_timeout():
	speed = 300.0
	$"timers/Dash cooldown".start()

func _on_dash_cooldown_timeout():
	print("Dash cooldown down")
	dash_cooldown = false
