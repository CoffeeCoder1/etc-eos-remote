extends Node

@onready var osc_client_tcp: OSCClientTCP = $OSCClientTCP
@onready var osc_user: OSCUser = $OSCUser


func _ready() -> void:
	AppSettings.ip_address_set.connect(_on_settings_ip_address_set)
	_on_settings_ip_address_set(AppSettings.get_ip_address())
	AppSettings.port_set.connect(_on_settings_port_set)
	_on_settings_port_set(AppSettings.get_port())
	AppSettings.user_id_set.connect(_on_settings_user_id_set)
	_on_settings_user_id_set(AppSettings.get_user_id())


func get_client() -> OSCClientTCP:
	return osc_client_tcp


func get_user() -> OSCUser:
	return osc_user


func _on_settings_ip_address_set(new_ip_address: String) -> void:
	osc_client_tcp.ip_address = new_ip_address


func _on_settings_port_set(new_port: int) -> void:
	osc_client_tcp.port = new_port


func _on_settings_user_id_set(new_user_id: int) -> void:
	osc_user.user_number = new_user_id
