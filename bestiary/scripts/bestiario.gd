extends CanvasLayer

@onready var container = $Panel/ScrollContainer/VBoxContainer

func _ready():
	hide()
	BestiaryData.load_bestiary()
	_update_bestiary()
	

func _update_bestiary():
	for child in container.get_children():
		container.remove_child(child)
		child.queue_free()
	
	@warning_ignore("shadowed_variable_base_class")
	for name in BestiaryData.enemies.keys():
		var enemy = BestiaryData.enemies[name]
		
		var box = HBoxContainer.new()
		
		var icon = TextureRect.new()
		icon.texture = load(enemy.icon_path)
		icon.custom_minimum_size = Vector2(64, 64)
		box.add_child(icon)
		
		var label = Label.new()
		if enemy.unlocked:
			label.text = "%s\nMortes: %d\n%s" % [name.capitalize(), enemy.kills, enemy.description]
		else:
			label.text = "???\nDesconhecido"
		box.add_child(label)
		
		container.add_child(box)

func show_bestiary():
	_update_bestiary()
	show()


func _on_button_pressed() -> void:
	hide()
