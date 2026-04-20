extends CharacterBody2D

@export var player_id:int=1
@export var sprite:AnimatedSprite2D
@export var speed = 300.0
@export var jump = -400.0


func _ready():
	if sprite:
		$AnimatedSprite2D.sprite_frames = sprite

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var action_left = "p%d_izquierda" % player_id
	var action_right = "p%d_derecha" % player_id
	var action_jump = "p%d_arriba" % player_id

	# Handle jump.
	if Input.is_action_just_pressed(action_jump) and is_on_floor():
		velocity.y = jump

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis(action_left, action_right)
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
	
func game_over(body: Node2D) -> void:
	get_tree().call_deferred("reload_current_scene")
