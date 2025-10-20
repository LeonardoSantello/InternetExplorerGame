extends CharacterBody2D

class_name portal

var health = 30

var dead: bool = false
var taking_damage: bool = false
@export var deathParticle : PackedScene 

var dir: Vector2
var is_roaming: bool = true

var player: CharacterBody2D
	
func _physics_process(_delta) -> void:
		
	player = Global.playerBody
	handle_animation()
	move_and_slide()

func handle_animation():
	var animation = $AnimationPlayer
	if not dead and taking_damage:
		animation.play("hurt")
		await get_tree().create_timer(0.5).timeout
		taking_damage = false
	elif dead and is_roaming:
		is_roaming = false
		animation.play("dead")
		$hitBox/CollisionShape2D.disabled = true
		await  get_tree().create_timer(1).timeout
		deathParticleFunc()
		print(str(self), "Morreu")
		self.queue_free()

func deathParticleFunc():
	var _particle = deathParticle.instantiate()
	_particle.position = global_position
	_particle.rotation = global_rotation
	_particle.emitting = true
	get_tree().current_scene.add_child(_particle)


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
