extends CharacterBody2D

# ==============================
# CONSTANTES
# ==============================
const JUMP_VELOCITY = -400.0
const ATTACK_DURATION = 0.45
const MAX_JUMPS = 2    # pulo duplo
const WALL_SLIDE_SPEED = 50 # velocidade ao deslizar na parede

# ==============================
# VARIÁVEIS
# ==============================
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var dust_start: GPUParticles2D = $DustStart
@onready var dust_running: GPUParticles2D = $DustRunning

var speed = 300.0
var is_attacking: bool = false
var attack_timer: float = 0.0
var jumps_left: int = MAX_JUMPS
var wall_contact_time := 0.0
var is_wall_sliding := false
var jump_time := 0.0
var dash_cooldown := false
var is_running := false   # nova variável para controlar estado de corrida

# ==============================
# FUNÇÕES PRINCIPAIS
# ==============================
func _physics_process(delta: float):
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
	# DETECTA INÍCIO DE CORRIDA
	# ==============================
	if direction != 0 and not is_running:
		is_running = true
		dust_start.emitting = true   # dispara a poeira do início
		dust_running.emitting = true # poeira contínua enquanto corre
	elif direction == 0 and is_running:
		is_running = false
		dust_running.emitting = false

	# ==============================
	# ATAQUE
	# ==============================
	if Input.is_action_just_pressed("attack") and not is_attacking:
		is_attacking = true
		attack_timer = ATTACK_DURATION
		$AnimationPlayer.play("attack")

	# ==============================
	# DASH
	# ==============================
	if Input.is_action_just_pressed("dash") and not dash_cooldown and not is_attacking and direction != 0:
		$Dash.start()
		dash_cooldown = true
		speed *= 3
		velocity.x = direction * speed

	# Gravidade
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		jumps_left = MAX_JUMPS # reseta os pulos quando toca no chão

	# ==============================
	# PULO E WALL JUMP
	# ==============================
	if Input.is_action_just_pressed("space") and not is_attacking:
		if is_wall_sliding:
			velocity.y = JUMP_VELOCITY
		elif jumps_left > 0:
			velocity.y = JUMP_VELOCITY
			jumps_left -= 1

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
			$AnimationPlayer.play("slide")
		elif speed > 300:
			$AnimationPlayer.play("dash_2")
		elif not is_on_floor():
			jump_time += delta
			if jump_time >= 0.2:
				$AnimationPlayer.play("jump")
		elif direction != 0:
			if direction < 0:
				$AnimationPlayer.play("run")
			else:
				$AnimationPlayer.play("run_right")
		else:
			jump_time = 0
			$AnimationPlayer.play("idle")

	# Espelhar sprite
	if direction < 0:
		anim.flip_h = true
	elif direction > 0:
		anim.flip_h = false

func _on_dash_timeout():
	speed = 300.0
	$"Dash cooldown".start()

func _on_dash_cooldown_timeout():
	print("Dash cooldown down")
	dash_cooldown = false
