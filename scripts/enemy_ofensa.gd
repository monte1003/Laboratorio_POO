extends Area2D
@export var speed:int = 200
@export var face_left = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if face_left:
		position.x -= speed * delta
	else:
		position.x += speed * delta

# --- LO QUE SE AÑADIÓ PARA EL PLAYER ---
func _on_body_entered(body: Node2D) -> void:
	if body.has_method("game_over"):
		body.game_over(body)
# ---------------------------------------

func _on_area_entered(area: Area2D) -> void:
	face_left = !face_left
