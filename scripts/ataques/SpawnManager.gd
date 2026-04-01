extends Node2D

# Cargamos las escenas usando las rutas de carpetas (REVISADO)
var escena_mensaje = preload("res://scenes/ataques/MensajeOfensivo.tscn")
var escena_rumor = preload("res://scenes/ataques/ObstaculoRumor.tscn")

var timer: Timer

func _ready() -> void:
	# Creamos el temporizador
	timer = Timer.new()
	timer.wait_time = 1.5
	timer.autostart = true
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)
	print("Generador listo: Lanzando ataques cada 1.5s")

func _on_timer_timeout() -> void:
	# 1. Elegimos la escena al azar
	var opciones = [escena_mensaje, escena_rumor]
	var elegida = opciones.pick_random()
	
	# 2. Creamos la instancia
	var instancia = elegida.instantiate()
	
	# 3. Agregamos al mundo (importante hacerlo antes de buscar nodos)
	get_tree().current_scene.add_child(instancia)
	
	# 4. Posicionamos
	instancia.global_position = Vector2(1100, randf_range(100, 500))
	
	# 5. CONFIGURACIÓN DEL LABEL 
	if instancia.has_node("Label"):
		var mi_label = instancia.get_node("Label")
		var frases = ["¡Inútil!", "¡Nadie te quiere!", "¡Fracasado!", "¡Qué mal lo haces!"]
		mi_label.text = frases.pick_random()
