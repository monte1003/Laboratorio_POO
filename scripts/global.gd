extends Node

# --- VARIABLES ---
signal update_heart
var heart: int = 0

# La instancia de tu Tabla Hash personalizada
var user_data = HashTable.new(20)

var bgm_player: AudioStreamPlayer

const LOG_PATH = "user://data.log"
const INDEX_PATH = "user://index.json"

func _ready():
	# El propio Global se encarga de cargar los datos al iniciar el juego
	setup_background_music()
	load_from_json()
	

func setup_background_music():
	bgm_player = AudioStreamPlayer.new()
	add_child(bgm_player)
	
	# Carga tu archivo de música (asegúrate de que la ruta sea correcta)
	bgm_player.stream = load("res://assets/textures/entities/background_music.mp3")
	
	bgm_player.volume_db = -12.0 # Ajusta el volumen para que no sature
	bgm_player.bus = "Master"
	
	# La música empieza a sonar automáticamente
	play_music()

func play_music():
	if bgm_player and not bgm_player.playing:
		bgm_player.play()
		
func stop_music():
	if bgm_player and bgm_player.playing:
		bgm_player.stop()
		

# --- REGISTRO ---
func register_user(username: String, password_text: String):
	# 1. Guardar en memoria (Hash Table)
	user_data.put(username, password_text)
	
	# 2. Guardar en el LOG (historial)
	var log_file = FileAccess.open(LOG_PATH, FileAccess.READ_WRITE)
	if not log_file:
		log_file = FileAccess.open(LOG_PATH, FileAccess.WRITE)
	
	if log_file:
		log_file.seek_end()
		var entry = {
			"user": username,
			"pass": password_text,
			"date": Time.get_datetime_string_from_system()
		}
		log_file.store_line(JSON.stringify(entry))
		log_file.close()
	
	# 3. Guardar el estado actual de la tabla en el JSON
	save_index()

# --- PERSISTENCIA ---
func save_index():
	var file = FileAccess.open(INDEX_PATH, FileAccess.WRITE)
	if file:
		var data_to_save = {
			"size": user_data.size,
			"table": user_data.table
		}
		file.store_string(JSON.stringify(data_to_save))
		file.close()
		print("Índice guardado en: ", INDEX_PATH)

func load_from_json():
	if not FileAccess.file_exists(INDEX_PATH):
		print("No existe archivo de índice. Iniciando nuevo.")
		return
		
	var file = FileAccess.open(INDEX_PATH, FileAccess.READ)
	if file:
		var json_helper = JSON.new()
		var content = file.get_as_text()
		file.close()
		
		var parse_result = json_helper.parse(content)
		if parse_result == OK:
			var data = json_helper.get_data()
			# Reconstruimos la tabla con los datos guardados
			user_data = HashTable.new(data["size"])
			user_data.table = data["table"]
			print("Usuarios cargados exitosamente.")
		else:
			print("Error al parsear JSON: ", json_helper.get_error_message())

func rebuild_index_from_log():
	if not FileAccess.file_exists(LOG_PATH):
		return
	
	user_data = HashTable.new(20)
	var log_file = FileAccess.open(LOG_PATH, FileAccess.READ)
	if log_file:
		while log_file.get_position() < log_file.get_length():
			var line = log_file.get_line()
			var json_helper = JSON.new()
			if json_helper.parse(line) == OK:
				var entry = json_helper.get_data()
				user_data.put(entry["user"], entry["pass"])
		log_file.close()
		save_index()
