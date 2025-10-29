extends Node2D

@onready var panel = $CanvasLayer/Control
@onready var btn_attack = $CanvasLayer/Control/HBoxContainer/btn_attack
@onready var btn_health = $CanvasLayer/Control/HBoxContainer/btn_health
@onready var btn_speed = $CanvasLayer/Control/HBoxContainer/btn_speed
@onready var area2d = $Area2D

var player_ref: Node = null

func _ready():
	panel.visible = false


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"): 
		player_ref = body
		panel.visible = true
		#get_tree().paused = true
		$"../..".process_mode = Node.PROCESS_MODE_DISABLED

func _apply_upgrade(stat: String):
	if not player_ref:
		print("Nenhum player encontrado!")
		return
	
	match stat:
		"attack":
			Global.playerDamageAmount *= 1.1
			print ("Ataque aumentado:")
		"health":
			Global.health += Global.health_max * 0.1
			Global.health_max *= 1.1
			print ("Vida aumentada:")
		"speed":
			Global.speed += 15
			print ("Velocidade aumentado:")

	panel.visible = false
	get_tree().paused = false
	queue_free()  


func _on_btn_attack_pressed():
	_apply_upgrade("attack")

func _on_btn_health_pressed():
	_apply_upgrade("health")

func _on_btn_speed_pressed():
	_apply_upgrade("speed")
