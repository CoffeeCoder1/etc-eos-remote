extends PanelContainer

## Emitted when the settings button is pressed.
signal settings_pressed


func _on_menu_button_pressed() -> void:
	show()


func _on_close_button_pressed() -> void:
	hide()


func _on_settings_button_pressed() -> void:
	settings_pressed.emit()
	hide()


func _on_disconnect_button_pressed() -> void:
	OSCGlobals.get_client().close_socket()
	hide()
