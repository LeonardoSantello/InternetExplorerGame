extends Node2D

@onready var animation: AnimationPlayer = $AnimationPlayer
var progress = []
func _ready() -> void:
	await get_tree().create_timer(0.5).timeout
	animation.play("fade_out")


func scene_transition_animation_function(scene_path: String) -> void:
	animation.play("fade_in")
	await animation.animation_finished
	print("Iniciando carregamento assíncrono...")
	ResourceLoader.load_threaded_request(scene_path)
	while true:
		var status = ResourceLoader.load_threaded_get_status(scene_path, progress)
		
		if status == ResourceLoader.THREAD_LOAD_LOADED:
			print("Cena carregada!")
			break
		elif status == ResourceLoader.THREAD_LOAD_FAILED:
			push_error("Falha ao carregar cena: " + scene_path)
			return
		
		await get_tree().create_timer(0.1).timeout  # Espera 0.1s antes de checar de novo (sem travar o jogo)

	var new_scene = ResourceLoader.load_threaded_get(scene_path)
	get_tree().change_scene_to_packed(new_scene)
