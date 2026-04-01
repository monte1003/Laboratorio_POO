extends EntidadAtaque

func _ready() -> void:
	super._ready() # Llama al código del padre para conectar el choque
	velocidad = 270.0 # Sobrescribe la velocidad del padre (es más rápido)
	danio = 1 # Puedes cambiar el daño si quieres que duela más

func aplicar_efecto(jugador: Node2D) -> void:
	# Efecto único: El rumor te empuja hacia atrás (daño emocional fuerte)
	print("¡Un rumor te ha golpeado!")
	jugador.global_position.x -= 50
	
	# También llamamos al daño estándar si el jugador tiene la función
	if jugador.has_method("recibir_danio"):
		jugador.recibir_danio(danio)
