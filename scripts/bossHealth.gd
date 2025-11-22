extends TextureProgressBar

var parent
var max_value_amount
var min_value_amount
var anim: bool = true
var anim_finished: bool = false
func _ready():
	parent = $"../../../boss"
	#self.min_value = parent.health_min
	self.max_value = parent.health_max

func _process(_delta):
	self.value = parent.health
	if Global.boss_started:
		self.visible = true
		if anim:
			anim = false
			$"../AnimationPlayer".play("open")
		if anim_finished:
			self.value = parent.health
		if parent.health == 0:
			self.visible = false
	else:
		self.visible = false


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	anim_finished = true
