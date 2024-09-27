extends PanelContainer


func _on_settings_button_pressed() -> void:
	show()


func _on_close_button_pressed() -> void:
	$"../../../OSCClientTCP".port = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/PortEdit.value
	hide()
