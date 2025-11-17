extends Node

var enemies := {}

func get_enemy(key:String) -> Dictionary:
	return enemies.get(key, {})

func load_all_enemies(paths:Array[String]) -> void:
	
	var lexer := DSLLexer.new()
	var parser := DSLParser.new()

	for path in paths:
		if not FileAccess.file_exists(path):
			push_error("Arquivo não encontrado: %s" % path)
			continue

		var f := FileAccess.open(path, FileAccess.READ)
		var content := f.get_as_text()

		var tokens = lexer.tokenize(content)
		var data   = parser.parse(tokens)

		if parser.errors.size() > 0:
			push_error("Erro em %s:" % path)
			for e in parser.errors:
				push_error(" - " + e)
			continue

		var key: String = normalize_key(data.get("titulo", "unknown"))

		# Mantém os campos com nomes consistentes
		enemies[key] = {
			"unlocked": data.get("unlocked", "false") == "true",
			"kills": int(data.get("kills", "0")),
			"description": data.get("texto", ""),
			"icon_path": data.get("icon", ""),
		}
		
func normalize_key(s: String) -> String:
	return s.strip_edges().to_lower().replace(" ", "_")
