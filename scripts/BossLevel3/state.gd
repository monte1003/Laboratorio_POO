extends Node2D

class_name State
#ABSTRACT CLASS

@onready var player = owner.get_parent().find_child("Player")
@onready var ray_cast = owner.find_child("RayCast2D")
@onready var debug = owner.find_child("debug")

func _ready() -> void:
	set_physics_process(false)
	
func enter():
	set_physics_process(true)
	
func exit():
	set_physics_process(false)
	
func transition():
	pass
	
func _physics_process(delta: float) -> void:
	transition()
	debug.text = name
