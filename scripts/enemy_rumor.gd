extends Area2D
@export var distance:float=600
@export var time:float=1.2
@export var transition:Tween.TransitionType

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = create_tween()
	
	tween.set_trans(transition)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_loops(-1)
	
	tween.tween_property(self,"position",Vector2.UP * distance, time).as_relative()
	tween.tween_property(self,"position",Vector2.DOWN * distance, time ).as_relative()

func _on_body_entered(body: Node2D) -> void:
	body.game_over()
