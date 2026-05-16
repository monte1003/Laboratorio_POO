extends Area2D

var direction = Vector2.RIGHT

@export var speed: float = 600


func _ready() -> void:
	rotation = direction.angle() + PI


func _physics_process(delta: float) -> void:
	position += direction * speed * delta


func _on_screen_exited() -> void:
	queue_free()
