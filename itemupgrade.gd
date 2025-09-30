extends Node2D

# ==============================
# NODES
# ==============================
@onready var panel = $CanvasLayer/Panel
@onready var btn_attack = $CanvasLayer/Panel/btn_attack
@onready var btn_health = $CanvasLayer/Panel/btn_health
@onready var btn_speed = $CanvasLayer/Panel/btn_speed
@onready var area2d = $Area2D

# ==============================
# VARIÁVEIS
# ==============================
var player_ref: Node = null

# ==============================
# READY
# ==============================
func _ready():
	panel.visible = false
	# Conecta os botões aos métodos
	btn_attack.pressed.connect(_on_attack_pressed)
	btn_health.pressed.connect(_on_health_pressed)
	btn_speed.pressed.connect(_on_btn_speed_pressed)
	# Conecta o sinal de entrada do Area2D
	area2d.body_entered.connect(_on_area_2d_body_entered)

# ==============================
# DETECTA PLAYER
# ==============================
func _on_area_2d_body_entered(body):
	if body.is_in_group("player"): 
		player_ref = body
		panel.visible = true
		get_tree().paused = true  # pausa o jogo

# ==============================
# APLICA UPGRADE
# ==============================
func _apply_upgrade(stat: String):
	if not player_ref:
		print("Nenhum player encontrado!")
		return
	
	match stat:
		"attack":
			player_ref.attack *= 1.05
			print("Attack agora:", player_ref.attack)
		"health":
			player_ref.max_health *= 1.05
			player_ref.health = player_ref.max_health
			print("Health agora:", player_ref.health)
		"speed":
			player_ref.speed *= 1.05
			print("Speed agora:", player_ref.speed)

	panel.visible = false
	get_tree().paused = false
	queue_free()  # remove o item da cena

# ==============================
# BOTÕES
# ==============================
func _on_attack_pressed():
	_apply_upgrade("attack")

func _on_health_pressed():
	_apply_upgrade("health")

func _on_btn_speed_pressed():
	_apply_upgrade("speed")
