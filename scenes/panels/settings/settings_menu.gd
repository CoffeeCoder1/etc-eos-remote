extends PanelContainer

signal user_selected(user_number: int)
signal ip_address_selected(ip_address: String)
signal port_selected(port: int)


func set_ip_address(ip_address: String) -> void:
	%IPAddressEdit.text = ip_address


func set_port(port: int) -> void:
	%PortEdit.value = port


func set_user(user: int) -> void:
	%UserEdit.value = user


func _on_settings_button_pressed() -> void:
	show()


func _on_close_button_pressed() -> void:
	port_selected.emit(%PortEdit.value)
	hide()


func _on_user_selected(user_number: int) -> void:
	user_selected.emit(user_number)


func _on_ip_address_submitted(new_text: String) -> void:
	ip_address_selected.emit(new_text)
