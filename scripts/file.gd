extends Area2D

func _on_body_entered(body: CharacterBody2D):
		get_parent().get_node("sfx_coin").play() #pega o som do node pai para tocar
