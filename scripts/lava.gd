extends Area2D

var velocidad = 85

func _process(delta):
	position.y -= velocidad * delta


func _on_body_entered(body: Node2D) -> void:

	if body.has_method("game_over"):

		for node in get_tree().get_nodes_in_group("players"):

			if node.has_method("game_over"):
				node.game_over()
