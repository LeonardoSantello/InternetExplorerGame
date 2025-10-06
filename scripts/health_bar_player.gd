extends TextureProgressBar

@onready var health_bar = $health_bar
@onready var damage_bar = $damageBar
@onready var health_label = $health
@onready var timer = $Timer

func _ready() -> void:
	health_bar.max_value = Global.health_max
	damage_bar.max_value = Global.health_max
	health_bar.value = Global.health
	damage_bar.value = Global.health
	update_health_label()

func _process(_delta: float) -> void:
	if int(health_bar.value) != int(Global.health):
		update_health()
		
	visible = Global.health > 0

func update_health() -> void:
	health_bar.max_value = Global.health_max
	damage_bar.max_value = Global.health_max
	health_bar.value = Global.health
	update_health_label()

	if Global.health < damage_bar.value:
		timer.start()
	else:
		damage_bar.value = Global.health

func update_health_label() -> void:
	health_label.text = "%d/%d" % [int(Global.health), int(Global.health_max)]

func _on_timer_timeout() -> void:
	damage_bar.value = Global.health
