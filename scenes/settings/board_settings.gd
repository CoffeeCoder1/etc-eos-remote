class_name BoardSettings extends Resource

## The name to display for the board.
@export var board_name: String
## IP address of the board to connect to.
@export var ip_address: String = "127.0.0.1":
	set(new_ip_address):
		ip_address_set.emit(new_ip_address)
		ip_address = new_ip_address
## Port of the board to connect to.
@export var port: int = 3037:
	set(new_port):
		port_set.emit(new_port)
		port = new_port

## Emitted when a new name is set.
signal name_set(name: String)
## Emitted when a new IP address is set.
signal ip_address_set(address: String)
## Emitted when a new port is set.
signal port_set(port: int)


func get_board_name() -> String:
	return board_name


func set_board_name(new_board_name: String) -> void:
	board_name = new_board_name


func get_ip_address() -> String:
	return ip_address


func set_ip_address(new_address: String) -> void:
	ip_address = new_address


func get_port() -> int:
	return port


func set_port(new_port: int) -> void:
	port = new_port
