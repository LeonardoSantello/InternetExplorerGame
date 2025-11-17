extends Node

var bestiary: Dictionary = {}  # salvável

func _ready():
	load_bestiary()
	initialize_missing_entries()
	create_bestiary()

func initialize_missing_entries():
	# AGORA acessamos o autoload corretamente
	for key in EnemyDatabase.enemies.keys():

		if not bestiary.has(key):

			var enemy = EnemyDatabase.enemies[key]
			var norm = normalize_key(key)
			bestiary[norm] = {
				"unlocked": false,
				"kills": 0,
				"description": enemy.get("description", ""),
				"icon_path": enemy.get("icon_path", "")
			}

func create_bestiary():
	if not bestiary.has('cmos'):
		bestiary['cmos'] = {
			"kills": 0,
			"unlocked": false
		}
	if not bestiary.has('virus'):
		bestiary['virus'] = {
			"kills": 0,
			"unlocked": false
		}
	if not bestiary.has('mal_cabeamento'):
		bestiary['mal_cabeamento'] = {
			"kills": 0,
			"unlocked": false
		}
	if not bestiary.has('cavalo_de_troia'):
		bestiary['cavalo_de_troia'] = {
			"kills": 0,
			"unlocked": false
		}
	save_bestiary()
		
func add_kill(enemy:String):
	enemy = enemy.to_lower()

	if not bestiary.has(enemy):
		bestiary[enemy] = {
			"kills": 0,
			"unlocked": true
		}
	
	bestiary[enemy].kills += 1
	bestiary[enemy].unlocked = true
	
	print(bestiary[enemy].kills)
	print(bestiary[enemy].unlocked)

	save_bestiary()

func save_bestiary():

	var f = FileAccess.open("user://bestiary.save", FileAccess.WRITE)
	f.store_var(bestiary)
	f.close()

func load_bestiary():
	if FileAccess.file_exists("user://bestiary.save"):
		var f = FileAccess.open("user://bestiary.save", FileAccess.READ)
		bestiary = f.get_var()
		f.close()

func normalize_key(s: String) -> String:
	return s.strip_edges().to_lower().replace(" ", "_")
