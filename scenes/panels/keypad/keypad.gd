extends PanelContainer

signal settings_button_pressed


func _on_settings_button_pressed() -> void:
	settings_button_pressed.emit()
