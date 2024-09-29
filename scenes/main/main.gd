extends Control


func _on_settings_user_selected(user_number: int) -> void:
	$OSCUser.user_number = user_number
