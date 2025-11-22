extends RichTextLabel

@export var player: Node2D  # Arraste o jogador no editor ou defina por código
@export var min_distance: float = 100.0  # Distância onde o texto fica totalmente visível
@export var max_distance: float = 300.0  # Distância onde o texto fica totalmente invisível
var can_talk: bool = false

var dialogues = [
	"A ola pequenino, você me acordou\n(Use 'E' para passar os dialogos)",
	"Então você é a causa daquele barulho mais cedo ?",
	"Ah, esqueci de me apresentar",
	"Eu sou um IBM 5150, mas pode me chamar de PC",
	"E você ? qual é seu nome ?",
	". . .",
	"Não é de falar muito ?",
	"Tudo bem, eu também não conseguiria falar depois de enfrentar o inimigo que voce teve a coragem de lutar contra",
	"Mas não se preocupe, você está no kernel agora",
	"O coração do sistema operacional, a última camada, o anel 0 . . .",
	"O que ? você quer voltar lá para cima ?",
	"Você não é qualquer programa",
	"Vejo potencial em você, e acredito que seja nossa última esperança",
	"Eu estou muito velho para me aventurar ao lado de fora, mas lhe desejo sorte",
	"Va, purifique cada componente desse computador, e traga a estabilidade a esse sistema"
]

var current_index = 0

func _ready() -> void:
	self.bbcode_text = "[font=res://assets/fonts/Px437_IBM_BIOS.ttf]" + dialogues[current_index] + "[/font]"
	
func _input(event):
	if event.is_action_pressed("fala") and can_talk:
		$"../Lights/AnimationPlayer".stop()
		$PressE.start()
		next_dialogue()

func next_dialogue():
	current_index += 1
	if current_index < dialogues.size():
		self.bbcode_text = "[font=res://assets/fonts/Px437_IBM_BIOS.ttf]" + dialogues[current_index] + "[/font]"
	else:
		$"../StaticBody2D".queue_free()
		self.text = "" # ou algo como "Fim do diálogo"

func _process(_delta):
	if dialogues.size() == current_index:
		$"../8BitBeepingComputer".stop()
		can_talk = false
		$"../Player".can_dash = true
		$"../AnimatedSprite2D/AnimationPlayer".play("off")
		self.visible = false
		
		Global.speed = 300
		self.queue_free()
		
	if player == null:
		return

	# Calcular o centro do texto
	var label_center_x = global_position.x + (size.x * 0.5)
	var x_distance = abs(label_center_x - player.global_position.x)

	var alpha := 1.0
	if x_distance <= min_distance:
		alpha = 1.0
	elif x_distance >= max_distance:
		alpha = 0.0
	else:
		alpha = 1.0 - ((x_distance - min_distance) / (max_distance - min_distance))

	modulate.a = alpha


func _on_area_2d_4_area_entered(area: Area2D) -> void:
	if area == Global.playerHitBox:
		$"../8BitBeepingComputer".play()
		Global.speed = 0
		can_talk = true
		$"../Player".can_dash = false
		$"../AnimatedSprite2D/AnimationPlayer".play("on")
		self.visible = true
		
		Global.speed = 0
		await get_tree().create_timer(0.1).timeout
		Global.speed = 0
		await get_tree().create_timer(0.1).timeout
		Global.speed = 0
		await get_tree().create_timer(0.1).timeout
		Global.speed = 0
		await get_tree().create_timer(0.1).timeout
		Global.speed = 0
		await get_tree().create_timer(0.1).timeout
		Global.speed = 0
		
		$"../areas2D/Area2D4".queue_free()


func _on_press_e_timeout() -> void:
	$"../Lights/AnimationPlayer".play("pressE")
