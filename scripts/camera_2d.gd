extends Camera2D

@export var p1:Node2D
@export var p2:Node2D

func _process(delta: float) -> void:
	if p1 and p2:
		global_position = (p1.global_position + p2.global_position) / 2
	else:
		global_position = p1.global_position
	
		
