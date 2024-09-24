extends Control


func _on_button_pressed(command: String) -> void:
	$OSCCommand.send_command(command)


func _on_key_pressed(key: String) -> void:
	$OSCKey.press_key(key)


func _on_key_released(key: String) -> void:
	$OSCKey.release_key(key)
