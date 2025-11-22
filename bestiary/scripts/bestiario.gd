extends CanvasLayer

@onready var container = $Panel/ScrollContainer/VBoxContainer

var enemy_db = EnemyDatabase

func _ready():
	enemy_db.load_all_enemies([
		"res://dsl/data/cmos.txt",
		"res://dsl/data/virus.txt",
		"res://dsl/data/mal_cabeamento.txt",
		"res://dsl/data/cavalo_de_troia.txt",
	])

	print("EnemyDatabase carregado: ", EnemyDatabase.enemies.keys())

	hide()
	BestiaryData.load_bestiary()

func _update_bestiary():
	# limpa de forma segura
	print("BestiaryData: ", BestiaryData.bestiary.keys())
	for child in container.get_children():
		child.queue_free()

	# itera inimigos
	for name in BestiaryData.bestiary.keys():
		var enemy = EnemyDatabase.enemies.get(name)
		print(name)
		print(enemy)

		if enemy == null:
			print("Aviso: inimigo ", name, " não existe em EnemyDatabase.")
			continue
			
		enemy.kills = BestiaryData.bestiary[name].kills
		enemy.unlocked = BestiaryData.bestiary[name].unlocked
		
		# container horizontal para cada linha
		var box = HBoxContainer.new()
		box.custom_minimum_size = Vector2(0, 140)
		box.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		# ícone
		var icon = TextureRect.new()
		icon.expand = true
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon.custom_minimum_size = Vector2(135, 135)

		var tex = null
		if enemy.unlocked:
			tex = load(enemy.icon_path)
		else:
			tex = load("res://bestiary/sprites/unknow.png")

		icon.texture = tex
		box.add_child(icon)

		# label com BBCode
		var label = RichTextLabel.new()
		label.bbcode_enabled = true
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		label.fit_content = true
		label.custom_minimum_size = Vector2(700, 135)
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		label.scroll_active = false

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
	
