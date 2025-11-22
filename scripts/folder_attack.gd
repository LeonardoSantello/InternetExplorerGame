extends Area2D
class_name folder
@onready var player = $"../../Player"
var direction: Vector2
var dir: Vector2
var acceleration: Vector2 = Vector2.ZERO 
var velocity: float
func _ready() -> void:
	direction = (player.global_position - global_position).normalized()
	dir = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()

func _physics_process(delta):
	
	acceleration = (player.position - position).normalized() * 700
	velocity = randi_range(200, 300)
	rotation = randi_range(0, 180)
	
	position += direction * velocity * delta

func _on_timer_timeout() -> void:
	self.queue_free()
