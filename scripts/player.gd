extends CharacterBody2D

@export var player_id: int = 1
@onready var _animated_sprite = $AnimatedSprite2D
@export var speed: float = 300.0
@export var jump: float = -400.0

# NUEVA VARIABLE: Controla si el jugador está vivo
var esta_vivo: bool = true 

func _physics_process(delta: float) -> void:
	# Si está muerto, no procesamos nada (gravedad, movimiento o animaciones)
	if not esta_vivo:
		return 
		
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var action_left = "p%d_izquierda" % player_id
	var action_right = "p%d_derecha" % player_id
	var action_jump = "p%d_arriba" % player_id

	if Input.is_action_just_pressed(action_jump) and is_on_floor():
		velocity.y = jump

	var direction := Input.get_axis(action_left, action_right)
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
	actualizar_visuales(direction)

func actualizar_visuales(direction):
	if not is_on_floor():
		_animated_sprite.play("jump")
	else:
		if direction != 0:
			if _animated_sprite.sprite_frames.has_animation("run"):
				_animated_sprite.play("run")
			else:
				_animated_sprite.play("idle")
		else:
			_animated_sprite.play("idle")
	
	if direction > 0:
		_animated_sprite.flip_h = false
	elif direction < 0:
		_animated_sprite.flip_h = true

# Asegúrate de que reciba el argumento 'body' que envían los enemigos
func game_over(target: Node2D) -> void:
	# Si yo (esta instancia) soy el objetivo de la muerte y sigo vivo...
	if target == self and esta_vivo:
		esta_vivo = false
		velocity = Vector2.ZERO
		_animated_sprite.play("death")
		
		await get_tree().create_timer(1.5).timeout
		get_tree().call_deferred("reload_current_scene")
