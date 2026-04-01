extends Area2D
class_name EntidadAtaque

# Configuración básica
var velocidad: float = 200.0
var danio: int = 1
var direccion: Vector2 = Vector2.LEFT

func _ready() -> void:
	# Conexión para detectar choques
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	# Movimiento constante
	global_position += direccion * velocidad * delta
	
	# Autodestrucción si se sale de la pantalla (para no gastar memoria)
	if global_position.x < -100:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("recibir_danio"):
		aplicar_efecto(body)
		queue_free()
	
# Esta función la rellenaremos en los hijos (Mensaje, Rumor, etc.)
func aplicar_efecto(jugador: Node2D) -> void:
	if jugador.has_method("recibir_danio"):
		jugador.recibir_danio(danio)
