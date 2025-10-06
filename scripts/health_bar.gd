extends ProgressBar

var parent
var max_value_amount
var min_value_amount

func _ready():
	parent = get_parent()
	#self.min_value = parent.health_min
	self.max_value = parent.health_max

func _process(_delta):
	self.value = parent.health
	if parent.health != parent.health_max:
		self.visible = true
		if parent.health == 0:
			self.visible = false
	else:
		self.visible = false
