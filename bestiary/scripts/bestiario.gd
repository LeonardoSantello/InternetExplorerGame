extends CanvasLayer

@onready var container = $Panel/ScrollContainer/VBoxContainer

func _ready():
	hide()
	BestiaryData.load_bestiary()
	_update_bestiary()

func _update_bestiary():
	# limpa de forma segura
	for child in container.get_children():
		child.queue_free()

	# itera inimigos
	for name in BestiaryData.enemies.keys():
		var enemy = BestiaryData.enemies[name]

		# container horizontal para cada linha
		var box = HBoxContainer.new()
		box.custom_minimum_size = Vector2(0, 140) # garante altura mínima da linha
		box.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		# ícone
		var icon = TextureRect.new()
		icon.expand = true
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon.custom_minimum_size = Vector2(135, 135)
		var tex = null
		if enemy.unlocked:
			# tenta carregar, mas checa se deu certo
			tex = load(enemy.icon_path) if ResourceLoader.exists(enemy.icon_path) else null
		else:
			tex = load("res://bestiary/sprites/unknow.png")
		if tex:
			icon.texture = tex
		else:
			# evita crash caso o path esteja errado
			print("Aviso: textura não encontrada para ", name, " -> ", enemy.icon_path)
		box.add_child(icon)

		# label com BBCode
		var label = RichTextLabel.new()
		label.bbcode_enabled = true
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		label.fit_content = true                   # tenta ajustar ao texto
		label.custom_minimum_size = Vector2(600, 135) # garante largura mínima
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		label.scroll_active = false                # desativa scroll automático
		
		var font = load("res://assets/fonts/Px437_IBM_BIOS.ttf")
		label.add_theme_font_override("normal_font", font)
		
		if enemy.unlocked:
			label.bbcode_text = "[color=black][font_size=20][font=res://assets/fonts/Px437_IBM_BIOS.ttf]%s[/font][/font_size][/color]\n\n[color=black]Eliminados:[/color] [color=red]%d[/color]\n\n[color=black][font=res://assets/fonts/Px437_IBM_BIOS.ttf]%s[/font][/color]\n\n\n\n" % [
				name.capitalize(),
				enemy.kills,
				enemy.description
				]
		else:
			label.bbcode_text = "[color=black]???[/color]\n[color=#636363]Desconhecido[/color]\n\n\n\n"

		box.add_child(label)
		container.add_child(box)


func show_bestiary():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	_update_bestiary()
	show()

func _on_button_pressed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	hide()
