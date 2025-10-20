extends Node

var enemies = {
	"cmos": {
		"unlocked": false,
		"kills": 0,
		"description": "Um autômato antigo criado a partir de circuitos esquecidos. 
		O Cmos patrulha áreas abandonadas em busca de energia.
		Atacando qualquer coisa que se aproxime de seus territórios.
		Apesar de sua aparência enferrujada, ele ainda é rápido e implacável.",
		"icon_path": "res://bestiary/sprites/cmos foto.png"
	},
}

func add_kill(enemy_name: String):
	if enemies.has(enemy_name):
		var e = enemies[enemy_name]
		e.kills += 1
		if e.kills == 1:
			e.unlocked = true
		enemies[enemy_name] = e
		save_bestiary()

func save_bestiary():
	var f = FileAccess.open("user://bestiary.save", FileAccess.WRITE)
	f.store_var(enemies)
	f.close()

func load_bestiary():
	if FileAccess.file_exists("user://bestiary.save"):
		var f = FileAccess.open("user://bestiary.save", FileAccess.READ)
		enemies = f.get_var()
		f.close()
