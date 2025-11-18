extends CharacterBody2D

class_name ddos

var health = 50
var health_max = 50
var dir: Vector2
var dead: bool = false
var taking_damage: bool = false
var is_dealing_damge: bool = false

func _ready() -> void:
	dir = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	Global.ddosDamageAmount = 10
	
func _physics_process(delta) -> void:

	handle_animation()

func handle_animation():
	var animation = $AnimationPlayer

	if not dead and taking_damage:
		$AnimatedSprite2D.play("damage")
		await get_tree().create_timer(0.3).timeout
		taking_damage = false
	elif dead:
		animation.play("dead")
		$hitBox/CollisionShape2D.disabled = true
		await  get_tree().create_timer(1).timeout
		print(str(self), "Morreu")
		self.queue_free()


func _on_hit_box_area_entered(area: Area2D) -> void:
	if area == Global.playerDamageZone and not taking_damage:
		var damage = Global.playerDamageAmount
		take_damage(damage)

func take_damage(damage):
	health -= damage
	taking_damage = true
	if health <= 0:
		health = 0
		dead = true
