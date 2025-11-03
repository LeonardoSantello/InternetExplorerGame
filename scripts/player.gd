extends CharacterBody2D
class_name Player

# ==============================
# CONSTANTES
# ==============================
const JUMP_VELOCITY = -500.0
const ATTACK_DURATION = 0.45
const WALL_SLIDE_SPEED = 50 # velocidade ao deslizar na parede

# ==============================
# VARIÁVEIS
# ==============================
@onready var playerHitBox: Area2D = $hitBox
@onready var deal_damage_zone: Area2D = $attack_area
@onready var anim: AnimatedSprite2D = $sprites/AnimatedSprite2D
@onready var dust_running: GPUParticles2D = $sprites/DustRunning
@onready var damage_animation = $ErroPopup/AnimationPlayer
@onready var sfx_jump: AudioStreamPlayer2D = $"audio/Windows7Balloon(jump)"
@onready var sfx_run: AudioStreamPlayer2D = $"audio/keyboard sound effect"
@onready var sfx_dash: AudioStreamPlayer2D = $audio/sfx_dash
@onready var sfx_attack: AudioStreamPlayer2D = $audio/sfx_attack

@export var can_slide: bool = true
@export var can_dash: bool = true
@export var max_jumps: int = 2    # pulo duplo

var is_attacking: bool = false
var jump_buffer_timer: float = 0.1
var jump_buffer: bool = false
var attack_timer: float
var jumps_left: int
var wall_contact_time := 0.0
var is_wall_sliding := false
var jump_time := 0.0
var dash_cooldown := false
var is_dashing := false
var attack: float = 10.0
var max_health: int = 100

var can_move := true
var can_take_damage: bool

# ==============================
# FUNÇÕES PRINCIPAIS
# ==============================
func _ready() -> void:
	Global.playerHitBox = playerHitBox
	Global.playerBody = self
	can_take_damage = true
	Global.playerAlive = true


func _physics_process(delta: float) -> void:
	Global.playerDamageZone = deal_damage_zone
	
	if not Global.playerAlive:
		return
	
	handle_input(delta)
	apply_gravity(delta)
	handle_jump()
	handle_wall_slide(delta)
	handle_attack()
	handle_dash()
	handle_run_effects()
	update_animation(delta)
	flip_sprite()
	check_hitbox()
	handle_bestiary()
	
	move_and_slide()


# ==============================
# BESTIARIO
# ==============================
func handle_bestiary() -> void:
	if Input.is_action_just_pressed("bestiary"):
		var bestiary = $Camera2D/bestiario
		if bestiary:
			if bestiary.visible:
				bestiary.hide()
			else:
				bestiary.show_bestiary()
		else:
			print("⚠️ Bestiário não encontrado!")

# ==============================
# MOVIMENTAÇÃO
# ==============================
func handle_input(delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")

	if is_attacking:
		velocity.x = 0
		attack_timer -= delta
		if attack_timer <= 0:
			is_attacking = false
	else:
		if is_dashing:
			if $sprites/AnimatedSprite2D.flip_h == true:
				velocity.x =  -Global.speed
			else:
				velocity.x = Global.speed
		elif can_move:
			velocity.x = direction * Global.speed if direction != 0 else move_toward(velocity.x, 0, Global.speed)
			#velocity.x = move_toward(velocity.x, direction * Global.speed, 600 * delta) if direction != 0 else move_toward(velocity.x, 0, Global.speed)
			#velocity.x = direction * Global.speed if direction != 0 else move_toward(velocity.x, 0, Global.speed)

# ==============================
# GRAVIDADE
# ==============================
func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		jumps_left = max_jumps
		if jump_buffer:
			velocity.y = JUMP_VELOCITY
			jump_buffer = false
		if Input.is_action_just_pressed("down"):
			position.y += 5


# ==============================
# PULO E WALL JUMP
# ==============================
func handle_jump() -> void:
	if Input.is_action_just_pressed("space") and not is_attacking:
		if is_wall_sliding or jumps_left > 0:
			velocity.y = JUMP_VELOCITY
			if not is_wall_sliding:
				jumps_left -= 1
				sfx_jump.play()
		else:
			jump_buffer = true
			get_tree().create_timer(jump_buffer_timer).timeout.connect(on_jump_buffer_timeout)
	elif (Input.is_action_just_released("space") or is_on_ceiling()) and velocity.y < 0:
		velocity.y *= 0.5


# ==============================
# WALL SLIDE
# ==============================
func handle_wall_slide(delta: float) -> void:
	if is_on_wall_only() and can_slide:
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
# ATAQUE
# ==============================
func handle_attack() -> void:
	if Input.is_action_just_pressed("attack") and not is_attacking and not is_wall_sliding:
		is_attacking = true
		toggle_damage_collision()
		attack_timer = ATTACK_DURATION
		$sprites/AnimationPlayer.play("longAttack1")
		$audio/sfx_attack.play()


# ==============================
# DASH
# ==============================
func handle_dash() -> void:
	if Input.is_action_just_pressed("dash") and not dash_cooldown and not is_attacking and can_dash:
		$timers/Dash.start()
		$Camera2D/CanvasLayer/dash_icon/Sprite2D/AnimationPlayer.play("dash_cooldown")
		is_dashing = true
		dash_cooldown = true
		Global.speed += 600
		sfx_dash.play()


# ==============================
# EFEITOS DE CORRIDA
# ==============================
func handle_run_effects() -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	var running := direction != 0 and is_on_floor()
	dust_running.emitting = running
	if running:
		if not sfx_run.playing:
			sfx_run.play()
	else:
		sfx_run.stop()


# ==============================
# ANIMAÇÕES
# ==============================
func update_animation(delta: float) -> void:
	var anim_player = $sprites/AnimationPlayer
	if is_attacking:
		return
	
	if is_wall_sliding:
		anim_player.play("slide")
	elif Global.speed >= 900:
		anim_player.play("dash")
	elif not is_on_floor():
		jump_time += delta
		if jump_time >= 0.2:
			anim_player.play("jump")
	elif Input.get_axis("ui_left", "ui_right") != 0:
		anim_player.play("run_left" if Input.get_axis("ui_left", "ui_right") < 0 else "run_right")
	else:
		jump_time = 0
		anim_player.play("idle")
		
	if not can_take_damage:
		damage_animation.play("poperror")
		$sprites/AnimationPlayer2.play("knockback")


# ==============================
# ESPELHAR SPRITE
# ==============================
func flip_sprite() -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		anim.flip_h = direction < 0
		deal_damage_zone.scale.x = -1 if direction < 0 else 1


func check_hitbox() -> void:
	var hitbox_areas = $hitBox.get_overlapping_areas()
	var damage: int
	if hitbox_areas:
		var hitbox = hitbox_areas.front()

		if hitbox.get_parent() is CmosEnemy:
			damage = Global.cmosDamageAmount
		elif hitbox.get_parent() is mal_cabeado:
			damage = Global.malCabeadoDamageAmount
		elif hitbox.get_parent() is inimigo_basico:
			damage = Global.inimigoBasicoDamageAmount
		elif hitbox.get_parent() is cavaloDeTroia:
			damage = Global.cavaloDeTroiaDamageAmount
		elif (hitbox.get_parent() is invader) or  (hitbox.get_parent() is invaderLifeTime):
			damage = Global.invaderDamageAmount
		elif hitbox.get_parent() is spike:
			damage = Global.spikeDamageAmount
		if can_take_damage and damage != 0:
			take_damage(damage)


func take_damage(damage) -> void:
	print(damage)
	if Global.health > 0:
		Global.health -= damage
		print("Vida player:", Global.health)
		print($hitBox.get_overlapping_areas().front().get_parent())
		if $hitBox.get_overlapping_areas().front().get_parent():
			velocity.x = $hitBox.get_overlapping_areas().front().get_parent().dir.x * 1000 #Knockback
		else:
			if $sprites/AnimatedSprite2D.flip_h == true:
				velocity.x = -1000
			else:
				velocity.x = 1000
		velocity.y = -400
		damage = 0
		can_move = false
		erro_change_position() 
		$timers/Knockback.start()
		if Global.health <= 0:
			Global.health = 0
			#Mutar outros sons
			Global.playerAlive = false
			handle_death_animation()
		take_damage_cooldown(2.0)


func erro_change_position() -> void:
	var random_value_x: float
	random_value_x = randi_range(-320, 270)
		
	if random_value_x < -260 or random_value_x > 210:
		$ErroPopup.position.x = random_value_x
		$ErroPopup.position.y = randi_range(-230, 80)
	else:
		erro_change_position()


func handle_death_animation() -> void:
	await get_tree().create_timer(0.2).timeout
	$sprites/AnimatedSprite2D.visible = false
	$Camera2D.zoom.x = 4
	$Camera2D.zoom.y = 4
	$Camera2D.position.y = 0
	$Camera2D/CanvasLayer/death/AnimationPlayer.play("death")
	print("DEAD")


func take_damage_cooldown(wait_time) -> void:
	can_take_damage = false
	await get_tree().create_timer(wait_time).timeout
	can_take_damage = true

func toggle_damage_collision() -> void:
	var damage_zone_collision = deal_damage_zone.get_node("CollisionShape2D")
	damage_zone_collision.disabled = false
	await get_tree().create_timer(ATTACK_DURATION).timeout
	damage_zone_collision.disabled = true

func set_damage() -> void:
	var current_damage_to_deal: int
	current_damage_to_deal = 10
	Global.playerDamageAmount = current_damage_to_deal


func _on_dash_timeout() -> void:
	is_dashing = false
	Global.speed = Global.speed - 600
	$"timers/Dash cooldown".start()

func _on_dash_cooldown_timeout() -> void:
	print("Dash cooldown down")
	dash_cooldown = false

func _on_knockback_timeout() -> void:
	can_move = true

func on_jump_buffer_timeout() -> void:
	jump_buffer = false
