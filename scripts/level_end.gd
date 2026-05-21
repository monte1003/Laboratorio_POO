extends Area2D

@export var load_level: String
@export var animation: AnimatedSprite2D
# Añadimos una variable exportada para asignar el nodo de sonido desde el Inspector
@export var win_sound: AudioStreamPlayer2D

func _on_body_entered(body: Node2D) -> void:
	# Verificamos que el cuerpo sea parte del grupo "jugadores"
	if body.is_in_group("jugadores"):
		# 1. Iniciamos la animación de la bandera
		animation.play("on")
		Global.stop_music()
		
		# 2. Reproducimos el sonido si el nodo está asignado
		if win_sound:
			win_sound.play()
		
		# 3. Bloqueamos el movimiento del jugador para que no siga caminando durante la espera
		body.set_physics_process(false)
		
		# 4. Esperamos los 2.5 segundos que definiste originalmente
		await get_tree().create_timer(2.5).timeout
		
		# 5. Cambiamos de nivel
		get_tree().change_scene_to_file(load_level)
