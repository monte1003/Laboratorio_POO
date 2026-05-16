extends State
class_name ShootState

@export var ray_1_node: PackedScene
@onready var timer = $Timer

func transition():
	if not ray_cast.is_colliding():
		get_parent().change_state("Follow")

func enter():
	super.enter()
	timer.start()
	
func exit():
	super.exit()
	timer.stop()

func _on_timer_timeout() -> void:
	shoot()
	
func shoot():
	var ray_1 = ray_1_node.instantiate()
	ray_1.position = global_position
	ray_1.direction = (player.global_position - global_position).normalized()
	
	get_tree().current_scene.call_deferred("add_child", ray_1)
