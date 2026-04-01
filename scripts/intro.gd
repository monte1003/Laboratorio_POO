# Solo lleva directamente a menu.tscn por ahora.
extends Control

func _on_Pasar_pressed() -> void: 
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
