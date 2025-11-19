extends RefCounted
class_name DSLToken

enum Type {
	LT, GT, IDENT, COLON,
	STRING,
	NUMBER,
	EOF
}

var type: int
var lexeme: String
var line: int
var col: int

func _init(_type:int, _lexeme:String, _line:int, _col:int) -> void:
	type = _type
	lexeme = _lexeme
	line = _line
	col = _col
