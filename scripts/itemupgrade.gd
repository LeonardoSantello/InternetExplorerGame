extends Node2D

@onready var panel = $CanvasLayer/Control
@onready var btn_attack = $CanvasLayer/Control/HBoxContainer/btn_attack
@onready var btn_health = $CanvasLayer/Control/HBoxContainer/btn_health
@onready var btn_speed = $CanvasLayer/Control/HBoxContainer/btn_speed
@onready var area2d = $Area2D

var player_ref: Node = null

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	panel.visible = false


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"): 
		$StartupSoundVariation6316850.play()
		player_ref = body
		panel.visible = true
		#get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		$"../..".process_mode = Node.PROCESS_MODE_DISABLED

func _apply_upgrade(stat: String):
	if not player_ref:
		print("Nenhum player encontrado!")
		return
	
	match stat:
		"attack":
			Global.playerDamageAmount *= 1.2
			print ("Ataque aumentado:")
		"health":
			Global.health += Global.health_max * 0.2
			Global.health_max *= 1.2
			print ("Vida aumentada:")
		"speed":
			Global.speed += 15
			Global.max_speed = Global.speed
			print ("Velocidade aumentado:")

	panel.visible = false
	#get_tree().paused = false
	$"../..".process_mode = Node.PROCESS_MODE_INHERIT
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	queue_free()  


func _on_btn_attack_pressed():
	_apply_upgrade("attack")

func _on_btn_health_pressed():
	_apply_upgrade("health")

func _on_btn_speed_pressed():
	_apply_upgrade("speed")
