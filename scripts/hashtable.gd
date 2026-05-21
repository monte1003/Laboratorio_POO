extends Node
class_name HashTable

var size: int
var count: int = 0
var load_factor_threshold: float = 0.75 # Factor de carga: 75%
var table: Array = []

func _init(_size = 16):
	self.size = _size
	_setup_table()

# Crea los "baldes" (buckets) vacíos
func _setup_table():
	table.clear()
	for i in range(size):
		table.append([]) # Cada espacio es un Array para manejar colisiones

# Función Hash: Convierte el texto en un número de índice
func _hash_function(key: String) -> int:
	var hash_val = 0
	for i in range(key.length()):
		# Algoritmo polinomial (común en ingeniería)
		hash_val = (hash_val * 31) + ord(key[i])
	return abs(hash_val) % size

# INSERTAR / ACTUALIZAR
func put(username: String, password: String):
	var index = _hash_function(username)
	
	# Manejo de Colisiones (recorremos el bucket)
	for entry in table[index]:
		if entry[0] == username:
			entry[1] = password # Si ya existe, actualiza la clave
			return
	
	# Si no existe, lo añadimos al final del bucket (Chaining)
	table[index].append([username, password])
	count += 1
	
	# REHASH: ¿La tabla está muy llena?
	if float(count) / size > load_factor_threshold:
		_rehash()

# REHASH: Crecer la tabla para que siempre sea rápida
func _rehash():
	print("--- INICIANDO REHASH (Factor de carga superado) ---")
	var old_table = table
	size = size * 2 # Duplicamos el tamaño
	count = 0
	_setup_table()
	
	# Volvemos a acomodar todos los usuarios en la nueva tabla más grande
	for bucket in old_table:
		for entry in bucket:
			put(entry[0], entry[1])
	print("--- REHASH COMPLETADO. Nuevo tamaño: ", size, " ---")

# BUSCAR
func get_password(username: String):
	var index = _hash_function(username)
	for entry in table[index]:
		if entry[0] == username:
			return entry[1]
	return null
