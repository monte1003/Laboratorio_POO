extends Area2D

@export var speed: float = 800.0
@export var lifetime: float = 3.0

# Esta variable la define el jugador al instanciarlo (1 = Derecha, -1 = Izquierda)
var direction: float =  1.0

func _ready() -> void:
	# Voltear visualmente el proyectil si va a la izquierda
	if direction < 0:
		scale.x = -1
		
	# Autodestruir el proyectil después de unos segundos para no llenar la memoria
	await get_tree().create_timer(lifetime).timeout
	queue_free()


func _process(delta: float) -> void:
	# Mover el proyectil horizontalmente
	position.x += speed * direction * delta


# Conecta la señal "body_entered" de este Area2D desde el editor a esta función
func _on_body_entered(body: Node2D) -> void:
	# Evitar que el proyectil se destruya a sí mismo chocando con el jugador que lo lanzó
	if body.is_in_group("players"):
		return
		
	# Si el enemigo tiene una función para recibir daño, la llamamos:
	if body.has_method("take_damage"):
		body.take_damage()
		
	# Destruir el proyectil al impactar con cualquier otra superficie (suelo, paredes, enemigos)
	queue_free()
