extends Control


func _ready() -> void:
	%SettingsContainer.set_ip_address($OSCClientTCP.ip_address)
	%SettingsContainer.set_port($OSCClientTCP.port)
	%SettingsContainer.set_user($OSCUser.user_number)


func _on_settings_user_selected(user_number: int) -> void:
	$OSCUser.user_number = user_number


func _on_settings_ip_address_selected(ip_address: String) -> void:
	$OSCClientTCP.ip_address = ip_address


func _on_settings_port_selected(port: int) -> void:
	$OSCClientTCP.port = port
