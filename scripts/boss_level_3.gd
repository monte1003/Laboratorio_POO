extends CharacterBody2D

@export var speed: float = 250.0
@export var fireball_scene: PackedScene

@onready var anim = $AnimatedSprite2D
@onready var attack_timer = $AttackTimer
@onready var phase_timer = $PhaseTimer

@onready var top_left = $TopLeft
@onready var top_right = $TopRight
@onready var bottom_left = $BottomLeft
@onready var bottom_right = $BottomRight

var target_position: Vector2

var points = []

var current_phase = 1

func _ready():

	points = [
		top_left.global_position,
		top_right.global_position,
		bottom_left.global_position,
		bottom_right.global_position
	]

	_pick_new_target()

	attack_timer.timeout.connect(_on_attack_timer_timeout)
	phase_timer.timeout.connect(_on_phase_timer_timeout)

	attack_timer.start()
	phase_timer.start()


func _physics_process(delta):

	match current_phase:

		1:
			move_pattern(delta)

		2:
			pass

		3:
			move_pattern(delta)

	move_and_slide()


# =========================
# MOVIMIENTO
# =========================

func move_pattern(delta):

	var direction = Vector2.ZERO

	# Movimiento horizontal primero
	if abs(global_position.x - target_position.x) > 5:

		direction.x = sign(target_position.x - global_position.x)

	# Luego vertical
	elif abs(global_position.y - target_position.y) > 5:

		direction.y = sign(target_position.y - global_position.y)

	else:
		_pick_new_target()

	velocity = direction * speed


func _pick_new_target():

	target_position = points[randi() % points.size()]


# =========================
# ATAQUES
# =========================

func _on_attack_timer_timeout():

	match current_phase:

		1:
			pass

		2:
			fire_rain()

		3:
			fire_rain()


func fire_rain():

	# MUCHAS bolas pequeñas
	for i in range(5):

		var fireball = fireball_scene.instantiate()

		get_parent().add_child(fireball)

		fireball.global_position = global_position

		# DIRECCIONES ALEATORIAS
		var dir = Vector2(
			randf_range(-1, 1),
			randf_range(0.2, 1)
		).normalized()

		fireball.direction = dir


# =========================
# FASES
# =========================

func _on_phase_timer_timeout():

	current_phase += 1

	if current_phase > 3:
		current_phase = 1

	print("FASE:", current_phase)
