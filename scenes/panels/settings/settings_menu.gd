extends PanelContainer

signal user_selected(user_number: int)


func _on_settings_button_pressed() -> void:
	show()


func _on_close_button_pressed() -> void:
	$"../../../OSCClientTCP".port = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/PortEdit.value
	hide()


func _on_user_selected(user_number: int) -> void:
	user_selected.emit(user_number)
