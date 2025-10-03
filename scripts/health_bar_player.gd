extends TextureProgressBar


func _process(delta):
	self.max_value = Global.health_max
	self.value = Global.health
	$health.text = str(Global.health) + "/" + str(Global.health_max)
	self.visible = true
	if Global.health == Global.health_min:
		self.visible = false
