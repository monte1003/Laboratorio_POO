extends Node2D
class_name State
#ABSTRACT CLASS

# --- MODIFICADO: Ahora lee el objetivo dinámico del script Principal ---
@onready var player = owner.player
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
	# Mantener actualizado el player local con el del owner por si cambia de objetivo
	player = owner.player
	transition()
	debug.text = name
