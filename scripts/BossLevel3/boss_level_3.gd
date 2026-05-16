extends CharacterBody2D

@onready var ray_cast = $RayCast2D

@export var distance:float = 420
@export var speed:float = 130
var direction = Vector2.RIGHT


@export var max_health: int = 200
var current_health: int

# Aquí guardaremos al jugador que está persiguiendo actualmente
var player: Node2D = null

func _ready() -> void:
	current_health = max_health
	set_physics_process(false)
	_find_closest_player()

func _process(delta: float) -> void:
	# Si el jugador objetivo murió o no existe, busca al otro
	if not is_instance_valid(player):
		_find_closest_player()
		return
		
	direction = (player.global_position - global_position).normalized()
	ray_cast.target_position = direction * distance
	
func _physics_process(delta: float) -> void:
	velocity = direction * speed
	move_and_slide()

# --- NUEVA FUNCIÓN: RECIBIR DAÑO ---
func take_damage() -> void:
	current_health -= 1
	
	
	# Efecto visual de parpadeo rojo (Opcional, pero recomendado)
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.RED, 0.1)
	tween.tween_property(self, "modulate", Color.WHITE, 0.1)
	
	if current_health <= 0:
		die()

func die() -> void:
	
	queue_free()

# --- NUEVA FUNCIÓN: ACTUALIZAR OBJETIVO MULTIJUGADOR ---
func _find_closest_player() -> void:
	var players = get_tree().get_nodes_in_group("players")
	if players.size() == 0:
		return
		
	var closest_player = players[0]
	var shortest_distance = global_position.distance_to(closest_player.global_position)
	
	for p in players:
		var dist = global_position.distance_to(p.global_position)
		if dist < shortest_distance:
			shortest_distance = dist
			closest_player = p
			
	player = closest_player
