extends LineEdit


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = $"../../../../../../../../../OSCClientTCP".ip_address


func _on_text_submitted(new_text: String) -> void:
	$"../../../../../../../../../OSCClientTCP".ip_address = new_text
