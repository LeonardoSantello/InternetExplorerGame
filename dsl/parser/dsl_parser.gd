extends RefCounted
class_name DSLParser

const T = DSLToken.Type

var _tokens: Array[DSLToken]
var _i := 0
var errors: Array[String] = []


func parse(tokens:Array[DSLToken]) -> Dictionary:
	_tokens = tokens
	_i = 0
	errors.clear()

	var data := {}

	while not _is_at_end():
		var tag := _parse_tag_line()
		if tag.size() == 0:
			if not _is_at_end():
				_advance()
			continue

		data[tag["name"].to_lower()] = tag["value"]

	if errors.size() > 0:
		return {}

	return data

# ==============================
# PARSE DE LINHA <TAG: valor>
# ==============================
func _parse_tag_line() -> Dictionary:
	if _check(T.EOF):
		return {}

	if not _check(T.LT):
		_error_at(_peek(), "Esperado '<' no início da tag.")
		return {}

	_consume(T.LT, "Esperado '<' no início da tag.'")

	var name := _consume_ident("Esperado nome da tag (ex.: TITULO, TEXTO).")
	_consume(T.COLON, "Esperado ':' após o nome da tag.")

	# valor pode ser STRING ("texto") ou IDENT (texto)
	var value := ""
	if _check(T.STRING):
		value = _advance().lexeme
	elif _check(T.IDENT):
		value = _advance().lexeme
	else:
		_error_at(_peek(), "Esperado texto após ':'.")
		return {}

	_consume(T.GT, "Esperado '>' ao final da tag.")

	var tok := _previous()

	return {
		"name": name.to_upper(),
		"value": value,
		"line": tok.line,
		"col": tok.col,
	}

# =============================
# Utils do parser
# =============================
func _check(tp:int) -> bool:
	return _peek().type == tp

func _advance() -> DSLToken:
	if not _is_at_end():
		_i += 1
	return _previous()

func _is_at_end() -> bool:
	return _peek().type == T.EOF

func _peek() -> DSLToken:
	return _tokens[_i]

func _previous() -> DSLToken:
	return _tokens[_i - 1]

func _consume(tp:int, msg:String) -> void:
	if _check(tp):
		_advance()
		return
	_error_at(_peek(), msg)

func _consume_ident(msg:String) -> String:
	if _check(T.IDENT):
		return _advance().lexeme
	_error_at(_peek(), msg)
	return ""

func _error_at(tok:DSLToken, msg:String) -> void:
	errors.append("%s (linha %d, col %d)" % [
		msg, tok.line, tok.col
	])
