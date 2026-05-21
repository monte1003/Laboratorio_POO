extends Control

# Referencias a los nodos de tu escena
@onready var user_input = $username
@onready var pass_input = $password
@onready var error_label = $error_label

func _ready():
	# Limpiamos el mensaje de error al iniciar
	error_label.text = ""

func _on_register_button_pressed() -> void:
	var user = user_input.text
	var typed_pass = pass_input.text
	
	# 1. Validación básica: ¿están vacíos?
	if user == "" or typed_pass == "":
		error_label.text = "¡Oye! No puedes dejar campos vacíos."
		return

	# 2. Verificar si el usuario ya existe en la Tabla Hash
	if Global.user_data.get_password(user) != null:
		error_label.text = "Ese usuario ya existe. Intenta con otro."
	else:
		# 3. ¡REGISTRO EXITOSO! 
		Global.register_user(user, typed_pass)
		
		error_label.text = "¡Usuario registrado con éxito!"
		
		# Esperamos un segundo para que el usuario vea el mensaje de éxito
		await get_tree().create_timer(1.2).timeout
		
		# 4. Redirigir al Login
		get_tree().change_scene_to_file("res://scenes/login.tscn")
