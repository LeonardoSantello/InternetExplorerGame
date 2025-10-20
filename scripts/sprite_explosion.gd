extends GPUParticles2D

@onready var timeCreated = Time.get_ticks_msec()

func _process(_delta: float) -> void:
	if Time.get_ticks_msec() - timeCreated > 1000:
		queue_free()
