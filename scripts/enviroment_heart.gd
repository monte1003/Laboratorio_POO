extends Area2D


@export var value:int = 1


func _on_body_entered(body: Node2D) -> void:
	Global.heart += value
	Global.update_heart.emit()
	print(Global.heart)
	queue_free()
