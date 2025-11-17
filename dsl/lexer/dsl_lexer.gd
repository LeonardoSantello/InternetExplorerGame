extends RefCounted
class_name DSLLexer

const T = DSLToken.Type

var _src := ""
var _i := 0
var _line := 1
var _col := 1

func tokenize(src:String) -> Array[DSLToken]:
	_src = src
	_i = 0
	_line = 1
	_col = 1
	var out: Array[DSLToken] = []

	while not _eof():
		var c := _peek()

		# whitespace
		if c == " " or c == "\t" or c == "\r":
			_advance()
			continue

		# newline
		if c == "\n":
			_advance()
			_line += 1
			_col = 1
			continue

		# comments
		if c == "#":
			_skip_to_eol()
			continue

		# INÍCIO DE TAG COMPLETA <IDENT:VALOR>
		if c == "<":
			var token = _read_tag_block()
			if token != null:
				out.append_array(token)
				continue
			else:
				push_error("Erro ao ler tag em %d:%d" % [_line, _col])
				_advance()
				continue

		# fallback: caracteres fora de tags são ignorados
		_advance()

	# EOF
	out.append(DSLToken.new(T.EOF, "", _line, _col))
	return out


# ============================================================
#  LÊ <IDENT:valor até o próximo >
# ============================================================
func _read_tag_block() -> Array:
	var tokens: Array[DSLToken] = []

	var start_line := _line
	var start_col := _col

	# consome <
	_advance()

	# IDENT
	var ident := ""
	while not _eof():
		var c := _peek()
		if c == ":":
			break
		if not _is_alnum(c) and c != "_":
			push_error("Nome de tag inválido em %d:%d" % [_line, _col])
			return []
		ident += _advance()

	# precisa ter encontrado :
	if _peek() != ":":
		push_error("Faltando ':' em tag na linha %d" % _line)
		return []

	# consome :
	_advance()

	# VALOR ATÉ >
	var value := ""
	while not _eof():
		var c := _peek()
		if c == ">":
			break
		value += _advance()

	# precisa terminar com >
	if _peek() != ">":
		push_error("Faltando '>' no final da tag na linha %d" % _line)
		return []

	# consome >
	_advance()

	# cria tokens
	tokens.append(DSLToken.new(T.LT, "<", start_line, start_col))
	tokens.append(DSLToken.new(T.IDENT, ident, start_line, start_col))
	tokens.append(DSLToken.new(T.COLON, ":", start_line, start_col))
	tokens.append(DSLToken.new(T.STRING, value.strip_edges(), start_line, start_col))
	tokens.append(DSLToken.new(T.GT, ">", start_line, start_col))

	return tokens


# ============================================================

func _skip_to_eol() -> void:
	while not _eof() and _peek() != "\n":
		_advance()

func _peek(offset:int = 0) -> String:
	var idx := _i + offset
	return _src[idx] if idx < _src.length() else ""

func _advance() -> String:
	var c := _src[_i]
	_i += 1
	_col += 1
	return c

func _eof() -> bool:
	return _i >= _src.length()

func _is_alpha(c:String) -> bool:
	return (c >= "A" and c <= "Z") or (c >= "a" and c <= "z")

func _is_digit(c:String) -> bool:
	return c >= "0" and c <= "9"

func _is_alnum(c:String) -> bool:
	return _is_alpha(c) or _is_digit(c)
