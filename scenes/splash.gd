extends Node2D

@export var title: String = "res://scenes/menu.tscn"
@onready var audio = $Jingle


# Called when the node enters the scene tree for the first time.
func _ready():
	# Start the sound
	audio.play()
	
	# Connect the signal: When audio stops, change scene
	audio.finished.connect(_change_to_title)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _change_to_title():
	# Stop the function from running twice if they skip AND the sound ends
	audio.finished.disconnect(_change_to_title)
	get_tree().change_scene_to_file(title)
