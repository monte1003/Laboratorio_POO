extends Camera2D

@export var p1: Node2D
@export var p2: Node2D

# Qué tan arriba quieres mover la cámara
@export var y_offset: float = -80

# Suavizado de movimiento
@export var smooth_speed: float = 5

func _process(delta: float) -> void:
	if not p1:
		return
	
	var target_position: Vector2
	
	if p2:
		# Punto medio entre ambos jugadores
		target_position = (p1.global_position + p2.global_position) / 2.0
	else:
		target_position = p1.global_position
	
	# Subir ligeramente la cámara en Y
	target_position.y += y_offset
	
	# Movimiento suave
	global_position = global_position.lerp(target_position,smooth_speed * delta)
	
		
