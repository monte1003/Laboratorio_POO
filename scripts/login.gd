extends Control

@onready var user_input = %"username"
@onready var pass_input = %"password"
@onready var error_label: Label = %"error_label"


func _ready():
	error_label.text = ""

func _on_pressed() -> void:
	# Verificamos que Global esté listo
	if Global == null:
		return

	var user = user_input.text
	var typed_pass = pass_input.text
	
	# Validación de campos vacíos
	if user == "" or typed_pass == "":
		error_label.text = "Por favor, llena todos los campos."
		error_label.modulate = Color.WHITE
		return

	# Obtenemos la contraseña desde la HashTable en Global
	var saved_pass = Global.user_data.get_password(user)
	
	if saved_pass == null:
		error_label.text = "El usuario no existe."
		error_label.modulate = Color.WHITE
		# Esperamos un segundo para que el usuario lea y luego vamos a registro
		await get_tree().create_timer(1.5).timeout
		get_tree().change_scene_to_file("res://scenes/register.tscn")
		
	elif saved_pass == typed_pass:
		error_label.text = "Cargando..."
		error_label.modulate = Color.WHITE
		entrar_al_juego()
	else:
		error_label.text = "Contraseña incorrecta."
		error_label.modulate = Color.WHITE

func entrar_al_juego():
	# Cambia esto a tu escena principal
	get_tree().change_scene_to_file("res://scenes/intro.tscn")
