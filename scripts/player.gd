extends CharacterBody2D

@export var player_id:int = 1

@export var speed:float = 300.0
@export var move_accel:float = 1200.0
@export var move_friction:float = 1800.0

@export var jump_force:float = -400.0
@export var jump_cut:float = 0.35

@onready var anim:AnimatedSprite2D = %AnimatedSprite2D

var action_left:String
var action_right:String
var action_jump:String

# NUEVO
var dead: bool = false


func _ready() -> void:
	action_left = "p%d_izquierda" % player_id
	action_right = "p%d_derecha" % player_id
	action_jump = "p%d_arriba" % player_id


func _physics_process(delta: float) -> void:
	# SI ESTA MUERTO
	if dead:
		velocity.x = 0
		move_and_slide()
		return
	
	_apply_gravity(delta)
	_handle_jump()
	_handle_movement(delta)
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


func _handle_animation() -> void:
	if not is_on_floor():
		anim.play("jump")
		return

	if abs(velocity.x) > 10:
		anim.play("walk")
	else:
		anim.play("idle")


func game_over(body: Node2D) -> void:
	dead = true
	
	
	velocity = Vector2.ZERO
	
	anim.play("death")

	await get_tree().create_timer(2.5).timeout
	
	get_tree().call_deferred("reload_current_scene")
