extends Control

@onready var settings_container: PanelContainer = %SettingsContainer
@onready var osc_user: OSCUser = $OSCUser
@onready var osc_client_tcp: OSCClientTCP = $OSCClientTCP


func _ready() -> void:
	settings_container.set_ip_address(osc_client_tcp.ip_address)
	settings_container.set_port(osc_client_tcp.port)
	settings_container.set_user(osc_user.user_number)


func _on_settings_user_selected(user_number: int) -> void:
	osc_user.user_number = user_number


func _on_settings_ip_address_selected(ip_address: String) -> void:
	osc_client_tcp.ip_address = ip_address


func _on_settings_port_selected(port: int) -> void:
	osc_client_tcp.port = port
