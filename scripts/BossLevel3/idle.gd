extends State
class_name IdleState

func transition():
	if ray_cast.is_colliding():
		get_parent().change_state("Shoot")
