class_name Settings extends Node

## IP address of the board to connect to.
@export var ip_address: String = "127.0.0.1":
	set(new_ip_address):
		ip_address_set.emit(new_ip_address)
		ip_address = new_ip_address
		save_settings()
## Port of the board to connect to.
@export var port: int = 3037:
	set(new_port):
		port_set.emit(new_port)
		port = new_port
		save_settings()
## User index to use when connecting to the board.
@export var user_id: int = -1:
	set(new_user_id):
		user_id_set.emit(new_user_id)
		user_id = new_user_id
		save_settings()
## Enables relative control of wheels.
@export var wheel_mode: Wheel.WheelMode = Wheel.WheelMode.RELATIVE:
	set(new_wheel_mode):
		Globals.set_wheel_modes(new_wheel_mode)
		wheel_mode = new_wheel_mode
		save_settings()

## Emitted when a new IP address is set.
signal ip_address_set(address: String)
## Emitted when a new port is set.
signal port_set(port: int)
## Emitted when a new user ID is set.
signal user_id_set(user_id: int)


func _ready() -> void:
	load_settings()


func serialize() -> Dictionary:
	return {
			"ip_address": ip_address,
			"port": port,
			"user_id": user_id,
			"wheel_mode": wheel_mode,
		}


func save_settings() -> void:
	var save_file = FileAccess.open("user://settings.save", FileAccess.WRITE)
	
	# JSON provides a static method to serialized JSON string.
	var json_string = JSON.stringify(serialize())
	
	# Store the save dictionary as a new line in the save file.
	save_file.store_line(json_string)


func load_settings() -> void:
	if FileAccess.file_exists("user://settings.save"):
		# Load the file line by line and process that dictionary.
		var save_file = FileAccess.open("user://settings.save", FileAccess.READ)
		while save_file.get_position() < save_file.get_length():
			var json_string = save_file.get_line()
			
			# Creates the helper class to interact with JSON.
			var json = JSON.new()
			
			# Check if there is any error while parsing the JSON string, skip in case of failure.
			var parse_result = json.parse(json_string)
			if not parse_result == OK:
				print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
				continue
			
			# Get the data from the JSON object.
			var node_data = json.data
			
			# Now we set the remaining variables.
			for key in node_data.keys():
				set(key, node_data[key])


func get_ip_address() -> String:
	return ip_address


func set_ip_address(new_address: String) -> void:
	ip_address = new_address


func get_port() -> int:
	return port


func set_port(new_port: int) -> void:
	port = new_port


func get_user_id() -> int:
	return user_id


func set_user_id(new_user_id: int) -> void:
	user_id = new_user_id


func get_wheel_mode() -> Wheel.WheelMode:
	return wheel_mode


func set_wheel_mode(new_wheel_mode: Wheel.WheelMode) -> void:
	wheel_mode = new_wheel_mode
