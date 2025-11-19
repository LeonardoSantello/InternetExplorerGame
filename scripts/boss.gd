extends CharacterBody2D

class_name boss
@export var deathParticle : PackedScene 

var health = 200
var health_max = 200
var dir: Vector2
var dead: bool = false
var taking_damage: bool = false
var is_dealing_damge: bool = false

func _ready() -> void:
	dir = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	Global.bossDamageAmount = 10
	
func _physics_process(_delta) -> void:
	handle_animation()

func handle_animation():
	var animation = $AnimationPlayer

	if not dead and taking_damage:
		$AnimatedSprite2D.play("damage")
		animation.play("hurt")
		await get_tree().create_timer(0.3).timeout
		taking_damage = false
	elif dead:
		$AnimatedSprite2D.play("damage")
		animation.play("dead")
		$hitBox/CollisionShape2D.disabled = true
		await  get_tree().create_timer(1).timeout
		print(str(self), "Morreu")
		deathParticleFunc()
		self.queue_free()
	else:
		$AnimatedSprite2D.play("idle")


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
		
func deathParticleFunc():
	var _particle = deathParticle.instantiate()
	_particle.position = global_position
	_particle.rotation = global_rotation
	_particle.emitting = true
	get_tree().current_scene.add_child(_particle)
