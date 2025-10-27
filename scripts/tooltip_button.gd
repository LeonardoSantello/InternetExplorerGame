extends Button

@onready var tooltip = $Tooltip

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)

func on_mouse_entered():
	print("Mouse entrou")
	tooltip.toggle(true)

func on_mouse_exited():
	print("Mouse saiu")
	tooltip.toggle(false)
