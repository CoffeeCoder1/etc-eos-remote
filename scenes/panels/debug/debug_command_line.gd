extends LineEdit


func _ready() -> void:
	text_submitted.connect(_on_text_submitted)


func _on_text_submitted(new_text: String) -> void:
	# TODO: Don't do this
	var target_client: OSCClientTCP = find_parent("Main").find_child("OSCClientTCP")
	target_client.send_message(new_text, [1.0])
