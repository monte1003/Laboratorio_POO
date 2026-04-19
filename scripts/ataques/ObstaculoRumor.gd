extends EntidadAtaque

# No necesitamos _process aquí porque ya lo hace el Padre (EntidadAtaque)

func _ready() -> void:
	super._ready() # VITAL: Conecta las señales de choque del padre
	
	# Personalización específica de esta variante
	velocidad = 295.0 
	modulate = Color.ORANGE # Se verá naranja automáticamente
	danio = 5 # Definimos el daño aquí directamente

func aplicar_efecto(jugador: Node2D) -> void:
	print("¡El rumor te arrastra!")
	
	# Llamamos al daño que definimos arriba
	if jugador.has_method("recibir_danio"):
		jugador.recibir_danio(danio)
	
	# Efecto de empuje (Knockback)
	# Restamos 100 en X para empujarlo a la izquierda
	jugador.global_position.x -= 100
