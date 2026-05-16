extends CharacterBody2D

@export var player_id:int = 1

@export var speed:float = 600
@export var move_accel:float = 1200.0
@export var move_friction:float = 4000

@export var jump_force:float = -800
@export var jump_cut:float = 0.35

@onready var anim:AnimatedSprite2D = %AnimatedSprite2D

var action_left:String
var action_right:String
var action_jump:String
var action_attack:String

var dead: bool = false

@export var projectile_scene: PackedScene


func _ready() -> void:
	add_to_group("players")
	
	action_left = "p%d_izquierda" % player_id
	action_right = "p%d_derecha" % player_id
	action_jump = "p%d_arriba" % player_id
	action_attack = "p%d_ataque" % player_id


func _physics_process(delta: float) -> void:
	# SI ESTA MUERTO
	if dead:
		velocity.x = 0
		move_and_slide()
		return
	
	_apply_gravity(delta)
	_handle_jump()
	_handle_movement(delta)
	_handle_attack()
	_handle_animation()
	
	move_and_slide()


func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta


func _handle_movement(delta: float) -> void:
	var direction := Input.get_axis(action_left, action_right)

	if direction != 0:
		velocity.x = move_toward(
			velocity.x,
			direction * speed,
			move_accel * delta
		)

		anim.flip_h = direction < 0

	else:
		velocity.x = move_toward(
			velocity.x,
			0,
			move_friction * delta
		)


func _handle_jump() -> void:
	if Input.is_action_just_pressed(action_jump) and is_on_floor():
		velocity.y = jump_force

	# Jump variable
	if Input.is_action_just_released(action_jump) and velocity.y < 0:
		velocity.y *= jump_cut
		
func _handle_attack() -> void:
	if Input.is_action_just_pressed(action_attack):
		if not projectile_scene:
			return
			
		# Instanciar el proyectil
		var projectile = projectile_scene.instantiate()
		
		# Determinar la dirección basada en el flip del sprite (-1 izquierda, 1 derecha)
		var direction = -1.0 if anim.flip_h else 1.0
		
		# Pasar la dirección y la posición inicial al proyectil
		projectile.direction = direction
		projectile.global_position = global_position
		
		# Añadirlo a la escena principal (para que no herede el movimiento del jugador)
		get_tree().current_scene.add_child(projectile)


func _handle_animation() -> void:
	if not is_on_floor():
		anim.play("jump")
		return

	if abs(velocity.x) > 10:
		anim.play("walk")
	else:
		anim.play("idle")


func game_over(body: Node2D) -> void:
	if dead:
		return
	dead = true
	velocity = Vector2.ZERO
	anim.play("death")
	

	if player_id == 1:
		await get_tree().create_timer(2.5).timeout
		get_tree().reload_current_scene()
