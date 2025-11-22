extends Area2D
class_name x

@onready var player = $"../../Player"
var direction: Vector2

var acceleration: Vector2 = Vector2.ZERO 
var velocity: float
var dir: Vector2
func _ready() -> void:
	dir = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	
func _physics_process(delta):
	direction = (player.global_position - global_position).normalized()
	acceleration = (player.position - position).normalized() * 700
	velocity = randi_range(150, 250)
	rotation = randi_range(0, 180)
	
	position += direction * velocity * delta

func _on_timer_timeout() -> void:
	self.queue_free()
