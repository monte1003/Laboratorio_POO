extends Area2D

# Esta variable controla qué tan rápido sube la lava
var velocidad = 85 

func _process(delta):
	# La posición Y disminuye para que la lava suba en la pantalla
	position.y -= velocidad * delta

func _on_body_entered(body: Node2D) -> void:
	body.game_over()
