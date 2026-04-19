extends Area2D

@export var load_level:String
@export var animation:AnimatedSprite2D

func _on_body_entered(body: Node2D) -> void:
	animation.play("on")
	await get_tree().create_timer(2.5).timeout
	get_tree().change_scene_to_file(load_level)
