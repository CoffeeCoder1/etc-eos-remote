extends PanelContainer


func _ready() -> void:
	%IPAddressEdit.text = OSCGlobals.get_client().ip_address
	%PortEdit.value = OSCGlobals.get_client().port
	%UserEdit.value = OSCGlobals.get_user().user_number


func _on_settings_button_pressed() -> void:
	show()


func _on_close_button_pressed() -> void:
	OSCGlobals.get_client().port = %PortEdit.value
	hide()


func _on_user_selected(user_number: int) -> void:
	OSCGlobals.get_user().user_number = user_number


func _on_ip_address_submitted(ip_address: String) -> void:
	OSCGlobals.get_client().ip_address = ip_address
