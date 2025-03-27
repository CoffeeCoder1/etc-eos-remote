class_name BoardMenu extends Menu

## Emitted when the settings button is pressed.
signal settings_pressed


func _on_close_button_pressed() -> void:
	close()


func _on_settings_button_pressed() -> void:
	settings_pressed.emit()


func _on_disconnect_button_pressed() -> void:
	OSCGlobals.get_client().close_socket()
	close()
