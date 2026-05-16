extends Camera2D

@export var p1: Node2D
@export var p2: Node2D

# Qué tan arriba quieres mover la cámara respecto al objetivo
@export var y_offset: float = -80

# Suavizado de movimiento
@export var smooth_speed: float = 5

# El punto límite en Y (en coordenadas globales) a partir del cual la cámara empezará a subir.
# Nota: En Godot, valores más negativos significan "más arriba".
@export var limite_subida_y: float = 200.0

func _process(delta: float) -> void:
	if not p1:
		return
	
	var target_position: Vector2
	
	if p2:
		# Punto medio entre ambos jugadores
		target_position = (p1.global_position + p2.global_position) / 2.0
	else:
		target_position = p1.global_position
	
	# --- CONTROL DE ALTURA (UMBRAL) ---
	# Si el punto medio no ha superado el límite (es decir, es mayor/más abajo en pantalla),
	# mantenemos la cámara fija en la altura del límite.
	if target_position.y > limite_subida_y:
		target_position.y = limite_subida_y
	
	# Aplicamos el offset vertical modificado
	target_position.y += y_offset
	
	# Mantener la posición X actual de la cámara si no quieres que se mueva en X, 
	# o dejar que siga a los jugadores en X (como hace tu código original):
	var final_target = Vector2(target_position.x, target_position.y)
	
	# Movimiento suave
	global_position = global_position.lerp(final_target, smooth_speed * delta)
