extends CharacterBody2D

@onready var ray_cast = $RayCast2D
@onready var player = get_parent().find_child("Player")

@export var distance:float = 420
@export var speed:float = 130
var direction = Vector2.RIGHT

func _ready() -> void:
	set_physics_process(false)

func _process(delta: float) -> void:
	direction = (player.position - global_position).normalized()
	ray_cast.target_position = direction * distance
	
func _physics_process(delta: float) -> void:
	velocity = direction * speed
	move_and_slide()
