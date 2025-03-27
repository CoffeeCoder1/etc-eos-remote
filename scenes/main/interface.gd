extends VBoxContainer

signal menu_button_pressed


func _on_menu_button_pressed() -> void:
	menu_button_pressed.emit()
